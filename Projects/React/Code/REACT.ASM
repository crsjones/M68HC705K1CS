;------------
; R E A C T !
;------------
;
; MC68HC705K1 based Reaction Timer
; by Craig R. S. Jones
; Version 1.0 September 1993
;
$nolist
$include        'k1def.asm'
$list
$base   10T
;
; Mask Option Register
;
; bit 7 SWPDI = 0 software pulldown enabled
; bit 6 PIN3  = 0 two pin oscillator configured
; bit 5 RC    = 0 Configure for crystal oscillator
; bit 4 SWAIT = 0 STOP instruction not converted to wait
; bit 3 LVRE  = 1 Low voltage reset enabled
; bit 2 PIRQ  = 1 PA3-PA0 enabled as external interrupt sources
; bit 1 LEVEL = 0 PA3-PA0 pins positive edge triggered only
; bit 0 COPEN = 1 COP watchdog enabled
;
;         MOR = $0d  ensure MOR register is programmed thus.
;
;------------------------
; ram variables and flags
;------------------------
        org    ramstart
flags   equ    $00e0        ;flag register
count   equ    0            ;count reaction time
beep    equ    1            ;beep flag
best    equ    2            ;best score flag
keyreg  equ    $00e1        ;push button flags
keya    equ    0            ;key a flag
keyap   equ    1            ;key a previous status
atrip   equ    2            ;key a trip
aearly  equ    3            ;key a too early
keyb    equ    4            ;key b flag
keybp   equ    5            ;key b previous status
btrip   equ    6            ;key b trip
bearly  equ    7            ;key b too early
tofcnt  equ    $00e2        ;TOF interrupt counter
rticnt  equ    $00e3        ;RTI interrupt counter
timouth equ    $00e4        ;off time counter h
timoutl equ    $00e5        ;off time counter l
deltim  equ    $00e6        ;beep delay time
units   equ    $00e7        ;scan register units
tens    equ    $00e8        ;scan register tens
hunds   equ    $00e9        ;scan register hundreds
counth  equ    $00ea        ;reaction time count register l
countl  equ    $00eb        ;reaction time count register h
countah equ    $00ec        ;a key reaction time l
countal equ    $00ed        ;a key reaction time h
countbh equ    $00ee        ;b key reaction time l
countbl equ    $00ef        ;b key reaction time h
bcountl equ    $00f0        ;best score low byte
bcounth equ    $00f1        ;best score high byte
;-----------------------
; initial power up reset
;-----------------------
        org    romstart
; when the unit is first connected to a battery
; the k1 powers up through reset.
; all that is required is for the ports to be set up
; and stop mode entered to wait for a key to wake
; the unit up.
;
; initialize port a
;
        clr    porta
        lda    #{ddra7.+ddra6.+ddra5.+ddra4.+ddra3.+ddra2.}
        sta    ddra
        sta    pdra
;
; initialize port b
;
        clr    portb
        lda    #{ddrb0.+ddrb1.}
        sta    ddrb
        lda    #$e7
        sta    bcountl
        lda    #$03
        sta    bcounth      ;initialize best score to 999
;
; enter stop mode to wait for key interrupt
;
        stop
;-----------------
; push button wake
;-----------------
; if in stop mode either key will power the k1 up
; via the external interrupt vector.
;
wake    bclr   irqe,iscr    ;disable further key interrupts
        bset   irqr,iscr    ;clear interrupt flag
        lda    #{toie.+rtie.+rt0.}   ;RTI rate 16ms
        sta    tcsr         ;enable RTI,TOF timer
;
;initialize ram
;
main    clra                ;clears
        ldx    #flags       ;ram from
main1   sta    0,x          ;00e0
        incx                ;clears ram from $e0
        cpx    #$f0         ;to $ef
        bne    main1
;
; show keys as pressed so that the interrupt
; routine will ignore the key press that turned the
; unit on.
;
        bset   keyap,keyreg
        bset   keybp,keyreg ;ignore power up key stroke
        bset   best,flags   ;show best score
        cli                 ;enable timer interrupts
        bset   beep,flags   ;power up beep
;
; wait for key to start random timer and show
; unit triggered.
;
        bsr    anykey
        bclr   best,flags   ;now triggered
;
; wait a random time.
; a rti occurs every 32ms, use the current value
; of tofcnt, as a pseudo-random number, and wait until
; this many rti interrupts have occured.
;
        clr    rticnt
        lda    tofcnt
main2   cmp    rticnt
        bne    main2
;
; once the random time has expired,check to see if anyone is
; cheating by pressing the button repeatedly, if so, set the
; too early flag.
;
        brclr  keya,keyreg,main3 ;key a been pressed since unit triggered?
        bset   aearly,keyreg     ;a player too early
main3   brclr  keyb,keyreg,main4 ;ket b been pressed since unit triggered?
        bset   bearly,keyreg     ;b player too early
;
; count reaction time.
; once the random delay has finished, enable count mode.
; do the beep while in count mode to ensure that any keys
; pressed during the beep are registered.
;
main4   bset   count,flags  ;enable count mode
        bset   beep,flags   ;initiate beep
;
; once count mode has been entered the tof interrupt
; routine will count milliseconds elapsed and save the
; time elapsed when the keys are pressed.
; when 999 milliseconds have elapsed, the tof interrupt
; routine will disable count mode to show that the
; timing period is finished.
;
main5   brset  count,flags,main5     ;wait until count mode finished
;
; when the timing period has finished,show the results
; only (and ignore the keys) so that any very late key presses
; do not skip displaying results entirely.
;
        lda    #63          ;show results for 2 seconds
main6   cmp    rticnt
        bne    main6
;
; now allow key press to restart
;
        bsr    anykey       ;display results until keypress
        bra    main         ;restart
;-----------------
; wait for any key
;-----------------
anykey  bclr   keya,keyreg
        bclr   keyb,keyreg  ;clear any key press
anyky1  brset  keya,keyreg,anyky2    ;key a?
        brclr  keyb,keyreg,anyky1    ;key b?
anyky2  bclr   keya,keyreg
        bclr   keyb,keyreg  ;clear key flags
        bset   beep,flags
anyky3  brset  beep,flags,anyky3     ;wait until beep finished
        rts
;--------------------------------
; timer interrupt service routine
;--------------------------------
timer   brset  tof,tcsr,tofint       ;tof interrupt
        jmp    rtint        ;real time interrupt
;-------------------------
; timer overflow interrupt
;-------------------------
; tof interrupts occur every 0.5 ms, the tof interrupt
; routine handles incrementing the reaction time, performs the
; beep and checks for key presses.
;
tofint  bset   tofr,tcsr    ;clear tof interrupt
        inc    tofcnt
        brclr  beep,flags,tofit2     ;beep on?
;
; do one beep cycle
;
        bset   1,portb      ;one tof interrupt occurs
        lda    #$53         ;every 0.5 mS (f = 2KHz)
tofit1  deca                ;so delay for 0.25 mS to
        bne    tofit1       ;produce a 2KHz square wave
        bclr   1,portb      ;to drive the buzzer
        inc    deltim       ;inc cycle count
        brclr  7,deltim,tofit2       ;finished beep?
        bclr   beep,flags   ;reset beep flag - beep done
        clr    deltim       ;clear cycle count
;
; increment reaction time counter
;
tofit2  brclr  count,flags,tstkey    ;not in count mode
;
; as TOF's occur each 0.5mS, only count every second one.
;
        brclr  0,tofcnt,tstkey       ;count every second TOF
        lda    #$03         ;has the
        cmp    counth       ;count reached
        bne    tofit4       ;999?
        lda    #$e7
        cmp    countl
        bne    tofit4       ;no, increment count
        bclr   count,flags  ;yes, stop count
;
; clear rticnt so that the show results routine will show
; the results in the correct order.
;
        clr    rticnt
        bra    tstkey       ;check the push buttons
;
; increment 16 bit counter
;
tofit4  inc    countl
        bne    tstkey
        inc    counth
;---------------
; key a pressed?
;---------------
; the test key routine looks for a rising edge on the
; port lines, to identify a keypress.
; it save the previous level of the port line so that
; it can determine wether the port line has had a low to
; high transition.
tstkey  brset  pa1,porta,pbkeya      ;key a pressed?
        bclr   keyap,keyreg          ;no, clear previous status
        bra    pbkeyb                ;check b key
;
; key a pressed was it pressed last time?
;
pbkeya  brset  keyap,keyreg,pbkeyb   ;pressed last time?
        bset   keya,keyreg           ;no,set key a flag
        bset   keyap,keyreg          ;set previous status
        clr    timoutl
        clr    timouth               ;reset timeout
;
; check reaction time
;
        brclr  count,flags,pbkeyb    ;skip if not count mode
        brset  aearly,keyreg,pbkeyb  ;a key too early so ignore
        brset  atrip,keyreg,pbkeyb   ;key a already tripped?
        bset   atrip,keyreg ;set key a trip
        bsr    chkbs        ;check for new best score
        lda    countl
        sta    countal
        lda    counth
        sta    countah      ;save a key reaction time
;---------------
; key b pressed?
;---------------
pbkeyb  brset  pa0,porta,pbkyb1      ;key b pressed?
        bclr   keybp,keyreg ;no,clear previous status
        rti
;
; key b pressed was it pressed last time?
;
pbkyb1  brset  keybp,keyreg,pbkyb2   ;pressed last time?
        bset   keyb,keyreg  ;no,set key b flag
        bset   keybp,keyreg ;set previous status
        clr    timoutl
        clr    timouth      ;reset timeout
;
; check reaction time
;
        brclr  count,flags,pbkyb2    ;skip if not count mode
        brset  bearly,keyreg,pbkyb2  ;b key too early so ignore
        brset  btrip,keyreg,pbkyb2   ;key b already tripped?
        bset   btrip,keyreg          ;set key b trip
        bsr    chkbs        ;check for new best score
        lda    countl       ;save reaction time
        sta    countbl
        lda    counth
        sta    countbh
pbkyb2  rti
;------------------------------------------------
; check if time is better than current best score
;------------------------------------------------
chkbs   ldx    counth
        lda    countl       ;get count
        sub    bcountl      ;check low byte
        bne    chkbs1
        txa
        sub    bcounth
        beq    chkbs2       ;both the same
chkbs1  txa
        sbc    bcounth
        bpl    chkbs2       ;slower than current best score
        lda    countl       ;new best score!
        sta    bcountl
        txa
        sta    bcounth      ;save new best score
chkbs2  rts
;--------------------
; real time interrupt
;--------------------
;the RTI interrupt occurs every 16 mS, it is used
;to :
;     - count the time since the last key was
;       pressed to go into stop mode after one minute
;     - handle the displaying of the results
;     - scanning the display
;
rtint   bset   rtifr,tcsr   ;clear real time interrupt
        lda    #0
        sta    copr         ;clear cop
        inc    rticnt       ;increment rti counter
;
; time to power down?
;
        lda    timoutl
        cmp    #$a6
        bne    rtint2
        lda    timouth
        cmp    #$0e
        bne    rtint2
;
; enter stop mode
;
rtint1  bset   irqr,iscr    ;reset any pending interrupts
        rsp                 ;reset stack pointer
        stop                ;shut down
;
; increment power down counter
;
rtint2  inc    timoutl
        bne    show
        inc    timouth
;----------------
; display results
;----------------
show    brset  count,flags,pbkyb2    ;skip if in count mode
        brset  beep,flags,pbkyb2     ;skip if beep on
        brset  atrip,keyreg,show3    ;key a trip?
        brset  btrip,keyreg,show1    ;key b trip?
        lda    countl                ;no keys tripped
        ldx    counth
        brclr  best,flags,show0      ;show best score
        lda    bcountl
        ldx    bcounth
show0   bra    convert
;
; only key b tripped
;
show1   brclr  5,rticnt,btime1       ;show __1
show2   lda    countbl
        ldx    countbh               ;b -> display
        bra    convert
;
; keys a and b tripped?
;
show3   brset  btrip,keyreg,show6    ;key b tripped as well?
;
; only key a tripped
;
show4   brclr  5,rticnt,atime1       ;show 1__
show5   lda    countal
        ldx    countah               ;a -> display
        bra    convert
;
; both keys tripped
;
show6   lda    countal
        sub    countbl      ;al - bl
        bne    show7        ;a = b?
        lda    countah
        sub    countbh      ;ah - bh
        beq    show5        ; a = b
show7   lda    countah
        sbc    countbh
        bmi    show8        ;a < b?
;
; a > b
;
        brclr  6,rticnt,show1        ;show b time
        brclr  5,rticnt,atime2       ;show 2__
        bra    show5                 ;a -> display
;
; a < b
;
show8   brclr  6,rticnt,show4        ;show a time
        brclr  5,rticnt,btime2       ;show __2
        bra    show2                 ;b -> display
;-----------------------
; display key a win/lose
;-----------------------
atime1  lda    #1           ;a won
        bra    atime3
atime2  lda    #2           ;a second
atime3  sta    hunds        ;show place on a key display
        lda    #$0f
        sta    tens
        sta    units        ;clear other displays
        bra    scan
;-----------------------
; display key b win/lose
;-----------------------
btime1  lda    #1           ;b won
        bra    btime3
btime2  lda    #2           ;b second
btime3  sta    units        ;show place on b key display
        lda    #$0f
        sta    tens
        sta    hunds        ;clear other displays
        bra    scan
;---------------
; convert to bcd
;---------------
; entry a = low byte
;       x = high byte
;
convert clr    hunds
        clr    tens
        clr    units        ;clear scan registers
convet1 sub    #100         ;subtract 100 from
        bcs    convet3      ;count until less than 100.
convet2 inc    hunds        ;count the number
        bra    convet1      ;of 100's subtracted.
;
; borrow from msb
;
convet3 decx                ;borrow from msb of count
        bpl    convet2      ;until nothing to borrow is left.
        add    #100         ;add 100 to restore remainder
;
; convert remainder to tens and units
;
convet4 sub    #10          ;subtract 10 from
        bcs    convet5      ;remainder until less than 10.
        inc    tens         ;count the number
        bra    convet4      ;of 10's subtracted.
convet5 add    #10          ;add 10 to restore remainder
        sta    units        ;which will be in BCD.
;-------------
; scan display
;-------------
scan    ldx    #units       ;point to display buffer
scan1   lda    0,x          ;get bcd to display
        asla
        asla
        asla
        asla                ;shift to msn to display
        cpx    #units       ;show units?
        bne    scan2
        sta    porta
        bset   0,portb      ;turn on units transistor
scan2   cpx    #tens        ;show tens?
        bne    scan3
        ora    #$04         ;turn on tens transistor
scan3   cpx    #hunds       ;show hundreds?
        bne    scan4
        ora    #$08         ;turn on hundreds transistor
scan4   sta    porta
        lda    #160         ;on time
scan5   deca
        bne    scan5        ;on time delay
        clr    portb        ;turn off
        clr    porta        ;displays
        incx
        cpx    #hunds+1
        bne    scan1        ;scan other displays
scan6   rti
;--------
; vectors
;--------
        org    vectors
        dw     timer        ;timer interrupt service routine
        dw     wake         ;external interrupt service routine
        dw     scan6        ;swi interrupt service routine
        dw     romstart     ;reset vector
$nolist








