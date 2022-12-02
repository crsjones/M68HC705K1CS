;--------------
; T I M E O U T
;--------------
;
; MC68HC705K1 based 60/90 second timer
; by Craig R. S. Jones
; Version 1.0 (c) 1993
;
$nolist
$include        'k1def.asm'
$list
$base   10T
;
; Mask Option Register
;
; bit 7 SWPDI = 0 software pulldown enabled
; bit 6 PIN3  = 1 three pin oscillator configured
; bit 5 RC    = 1 external RC network
; bit 4 SWAIT = 0 STOP instruction not converted to wait
; bit 3 LVRE  = 1 Low voltage reset enabled
; bit 2 PIRQ  = 1 PA3-PA0 enabled as external interrupt sources
; bit 1 LEVEL = 0 PA3-PA0 pins positive edge triggered only
; bit 0 COPEN = 1 COP watchdog enabled
;
;         MOR = $6d  ensure MOR register is programmed thus.
;
;------------------------
; ram variables and flags
;------------------------
        org     ramstart
flags   equ     $00e0           ;flag register
rtiflg  equ     0               ;Real Time Interrupt Flag
tofflg  equ     1               ;Timer Overflow Flag
go      equ     2               ;count down enable flag
keya    equ     3               ;push button A flag
keyb    equ     4               ;push button B flag
keyap   equ     5               ;push button A previous state
keybp   equ     6               ;push button B previous state
count   equ     $00e1           ;down count register
timout  equ     $00e2           ;power down timer
defalt  equ     $00e3           ;default start up time
tofcnt  equ     $00e4           ;tof interrupt counter
deltim  equ     $00e5           ;beep delay time
;-----------------------
; initial power up reset
;-----------------------
        org     romstart
;
; initialize port a
;
        clr     porta
        lda     #{ddra7.+ddra6.+ddra5.+ddra4.+ddra3.+ddra2.}
        sta     ddra
        sta     pdra
;
; initialize port b
;
        clr     portb
        lda     #ddrb0.
        sta     ddrb
;
; initialize registers
;
        clr     timout          ;clear power down timer
        clr     tofcnt          ;clear tof interrupt counter
        clr     flags           ;clear flag register
;
; initialize count down time default
;
        lda     #$60            ;BCD for 60 seconds
        sta     defalt
;
; enter stop mode to wait for key interrupt
;
        stop
;-----------------
; push button wake
;-----------------
wake    bclr    irqe,iscr       ;disable further key interrupts
        bset    irqr,iscr       ;clear interrupt flag
        lda     defalt          ;set down counter to
        sta     count           ;default count down time
        lda     #{toie.+rtie.+rt1.+rt0.}
        sta     tcsr            ;enable RTI,TOF timer
        bset    keyap,flags
        bset    keybp,flags     ;ignore power up key stroke
        cli                     ;enable timer interrupts
;----------------------------------
; wait for rti, tof interrupt flags
;----------------------------------
main    brset   rtiflg,flags,dobeep ;rti interrupt flag - handle beep
        brset   tofflg,flags,dokeys ;tof interrupt flag - handle keys
        bra     main
;-----------------------
; check if beep required
;-----------------------
dobeep  bclr    rtiflg,flags    ;clear rti flag
        brclr   go,flags,main   ;not counting down
;
; is count = 00?
;
        lda     count
        bne     dobep1          ;count not = 00
;
; do distinctive beep for 00
;
        ldx     #$80
        lda     #$08            ;set up beep
        bra     dobep4          ;do beep
;
; is least significant digit = 0?
;
dobep1  and     #$0f
        beq     dobep3          ;beep if count lsd = 0
;
; is most significant digit = 0?
;
dobep2  lda     count
        and     #$f0            ;beep if count msd = 0
        bne     main
dobep3  lda     #$03            ;set up beep
        ldx     #$30
dobep4  sta     deltim
        bsr     beep            ;do beep
        bra     main
;--------------------
; handle push buttons
;--------------------
dokeys  bclr    tofflg,flags    ;clear tof flag
        brset   keya,flags,keyahi   ;key A pressed?
        brset   keyb,flags,keybhi   ;key B pressed?
        bra     main            ;no keys pressed
;-------------
; handle key A
;-------------
keyahi  bclr    keya,flags      ;clear key A flag
;
; are we counting down?
;
        brclr   go,flags,keyai2 ;counting down?
;----------------------------
; counting down - reset timer
;----------------------------
        clr     timout          ;reset power down timer
        bclr    go,flags        ;stop count down
keyai1  lda     defalt
        sta     count           ;reset count
        bra     dokey1          ;do key beep
;------------------
; not counting down
;------------------
;
; if timer paused just relaod default
;
keyai2  lda     count
        cmp     #$90
        beq     keyai3          ;toggle default
        cmp     #$60
        beq     keyai3          ;toggle default
        bra     keyai1          ;relaod default
;
; toggle default time
;
keyai3  lda     defalt
        cmp     #$90            ;current default = 90?
        beq     keyai5
        lda     #$90            ;no, make it 90
keyai4  sta     defalt          ;new default time
        sta     count           ;new count
        bra     dokey1
keyai5  lda     #$60            ;make default 60
        bra     keyai4
;-------------
; handle key B
;-------------
keybhi  bclr    keyb,flags      ;clear key b flag
;
; are we counting down?
;
        brclr   go,flags,keybi1 ;counting down?
;----------------------------
; counting down - pause timer
;----------------------------
        bclr    go,flags        ;stop count down
        clr     timout          ;clear power down timer
        bra     dokey1
;--------------------
; start counting down
;--------------------
keybi1  bset    go,flags        ;start count down
;--------------------------
; acknowledge key with beep
;--------------------------
dokey1  lda     #$04
        ldx     #$20
        sta     deltim
        bsr     beep
        bra     main
;----------
; do a beep
;----------
; entry : deltim = 1/2 period
;         x = number of cycles
beep    sei                     ;disable TOF interrupts
beep1   bset    0,portb         ;set beeper output
        lda     deltim
loop1   deca                    ;delay 1/2 period
        bne     loop1
        bclr    0,portb         ;clear beeper output
        lda     deltim
loop2   deca                    ;delay 1/2 period
        bne     loop2
        decx
        bne     beep1           ;done all cycles?
        cli                     ;enable TOF interrupts
        rts
;--------------------------------
; timer interrupt service routine
;--------------------------------
timer   brset   tof,tcsr,tofint ;tof interrupt
;
; decrement time remaining counter
;
rtint   bset    rtifr,tcsr      ;clear real time interrupt
        bset    rtiflg,flags    ;set one second flag
        lda     #0
        sta     copr            ;clear cop
;
; are we counting down?
;
        brclr   go,flags,rtint3
;
;  count down
;
        lda     count           ;is lsd zero?
        and     #$0f
        beq     rtint1          ;lsd is zero
        dec     count           ;just dec and exit
        rti
rtint1  lda     count           ;is msd zero?
        and     #$f0
        beq     rtint2          ;msd is zero
        lda     count
        sub     #$07            ;tens roll over
        sta     count
        rti
;
; time remaining is zero - stop count down mode
;
rtint2  bclr    go,flags        ;stop count down mode
        clr     timout          ;clear power down timer
        lda     defalt
        sta     count           ;re-load default count
        rti
;-----------------------
; check power down delay
;-----------------------
rtint3  lda     timout
        cmpa    #60             ;time to power down?
        beq     rtint4          ;power down
        inc     timout          ;not yet inc timout
        rti
;
; stop processing
;
rtint4  bset    irqr,iscr       ;reset any pending interrupts
        clr     timout          ;clear power down timer
        rsp                     ;reset stack pointer
        stop                    ;shut down
;-------------
; scan display
;-------------
tofint  bset    tofr,tcsr       ;clear tof interrupt
        bset    tofflg,flags    ;set tof flag
        inc     tofcnt          ;inc tof counter
;
; if we are counting down - scan the display
;
        brset   go,flags,tofit1 ;are we counting down?
;
; if we are not counting down - blink the display
;
        brclr   5,tofcnt,tstkey ;skip scanning sometimes
;-----------------
; scan the display
;-----------------
tofit1  lda     count
        and     #$f0            ;strip lsd
        ora     #$08            ;turn on tens transistor
        sta     porta           ;output tens digit
        lda     #10
tofit2  deca
        bne     tofit2          ;tens on time delay
        lda     count
        and     #$0f            ;strip msd
        asla                    ;shift units
        asla                    ;to upper
        asla                    ;nybble
        asla                    ;for output
        ora     #$04            ;turn on units transistor
        sta     porta           ;output units digit
        lda     #10
tofit3  deca
        bne     tofit3          ;units on time delay
        clr     porta           ;turn off displays
;--------------------
; check for key press
;--------------------
tstkey  brclr   2,tofcnt,tstky4 ;allow debounce time
;
; key A pressed?
;
        brset   pa1,porta,tstky1   ;key A pressed
        bclr    keyap,flags     ;clear previous status
        bra     tstky2
;
; key A pressed, was it pressed last time?
;
tstky1  brset   keyap,flags,tstky2 ;pressed last time
        bset    keya,flags      ;set key A flag
        bset    keyap,flags     ;set previous status
;
; key b pressed?
;
tstky2  brset   pa0,porta,tstky3   ;key B pressed
        bclr    keybp,flags     ;clear previous status
        rti
;
; key B pressed, was it pressed last time?
;
tstky3  brset   keybp,flags,tstky4 ;pressed last time
        bset    keyb,flags      ;set key B flag
        bset    keybp,flags     ;set previous status
tstky4  rti
;--------
; vectors
;--------
        org     vectors
        dw      timer           ;timer interrupt service routine
        dw      wake            ;external interrupt service routine
        dw      tstky4          ;swi interrupt service routine
        dw      romstart        ;reset vector
$nolist
