
*
***************************************************************************
*  DEMO1: This program was written to demostrate the ICS05K "STEPFOR"
*         command. This command continuously executes instructions and
*         updates the screen with each execution; unlike the "GO" command
*         which does not update the display.
*
*         Note: The user must modify the MOR register ($0017) to $07 after
*               the program has been assembled and loaded into the ICS to
*               enable edge and level sensitive external interrupts, PA3-PA0
*               external interrupts, and the COP watchdog functions that
*               are used in this program.
*               ex) MM 17 07
*
***************************************************************************
*
*  RAM - variables
*
*
*  This is where you name your variables. Each one has
*  a label and a psuedo op defining how much space is
*  needed. This program uses eight consecutive bytes for storing data
*  read from the personality eprom, two single bytes for storing
*  the number of timer overflows and the number of external interrupts,
*  and two single bytes used for temporary storage.
*
    ORG  RAM       ;IASM05K contains several built-in labels or "tags"
                   ;with specific values. Most other assemblers do not
                   ;have this feature and the user would have to first
                   ;equate the tag to be used to a specific location.
                   ;ex.) RAM  EQU  $00E0.
prom ds 8
tim_counter ds 1
ext_counter ds 1
tempa ds 1
tempx ds 1
**************************************************************************
**************************************************************************
*  PROGRAM
*
*  The program resides in ROM. In this example, the
*  interrupt subroutines (TIMER_ISR and EXTERNAL_ISR) are the
*  first pieces of code. The actual program will start at label "start"
*  since that is specified in the reset vector at the end
*  of the program.
*
*
    ORG  ROM
*
*
*
* ISR - interrupt service routines
*       This program contains two interrupt service routines.
*       The first, TIMER_ISR, is executed when a timer overflow
*       occurs. The second, EXTERNAL_ISR, is executed when either
*       the IRQ pin goes low or any of the four lower bits of port a
*       go high.
*
TIMER_ISR:              ;this code executes if a timer overflow occurs
    inc  tim_counter    ;increment timer overflow counter
    bset 3,tcsr         ;clear timer overflow flag
    rti                 ;return to main program

EXTERNAL_ISR:           ;this code executes if an external interrupt occurs
    inc  ext_counter    ;increment external interrupt counter
    rti                 ;return to main program
*
*   INIT - Initialization routine
*          The program starts executing at the "START" tag then immediatly
*          jumps to this subroutine. It sets the direction of the porta
*          and portb pins, initializes storage locations in ram, and
*          enables the various interrupts used in this program.
*
INIT:
    clra
    lda  #0f0           ;configure upper four pins of port a as outputs,
                        ;lower four as inputs.
    sta  ddra
    lda  #03
    sta  ddrb           ;port b pins are outputs
    clrx                ;initialize x register to zero
    lda  #00
    sta  prtb           ;set port b pins to zero
    sta  prta           ;set all port a pins to zero
    sta  tim_counter    ;initialize storage for timer overflows
    sta  ext_counter    ;initialize storage for external interrupts
    sta  tempa          ;intialize temp storage for accumlutor value
    sta  tempx          ;intialize temp storage for x register value
zr  sta  prom,x         ;initialize 8 ram bytes for peprom data storage
    incx                ;increment x register by 1
    cpx  #08            ;compare x register to 8 and loop until equal to 0
    bne  zr
    clrx                ;clear x register
    bset 5,tcsr         ;enable timer overflow interrupts
    cli                 ;enable interrupts
    rts                 ;return to main program
***************************************************************************
*
***************************************************************************
*  START - main code
*          This program has two main functions. The first is to read the
*          eight bytes of data out of the personality eprom and store it
*          in ram. The second part of the program blinks LED1 on the KICS
*          PCB.
START:
     jsr  init             ;code often starts by an initialization routine
     stx  tempx            ;save current x register value in ram
     lda  #00
lp1  sta  pebsr            ;store 00 in peprom bit select register
loop rol pecsr             ;rotate the pedata into the carry bit
     rorx                  ;rotate the carry bit into the index register
     inc  pebsr            ;go to the next bit in the array
     brclr 0,pecsr,loop    ;go through 8 rows and when row0 is decoded
                           ;again then bit 0 will be set and the branch
                           ;will not occur
     jsr  store            ;store one byte of peprom data in ram and
                           ;increment ram address by one
     add  #08              ;advance to next column in peprom array
     cmp  #40              ;loop until all eight columns have been stored
     bne  lp1              ;branch
tag  lda  #00
     sta  cop              ;prevents cop from timing out
     lda  prta             ;load current value of porta into the accumulator
     eor  #80              ;eor bit 7 of port a
     sta  prta             ;set port a bit 7 to eor'ed value (toggle LED1)
     bra  tag              ;branch to reset cop and eor port a bit 7
*
*  STORE - Peprom data storage routine
*          This routine stores the data gathered from each byte of the peprom
*          in succesive locations in ram, beginning with the first location,
*          $00E0.
*
STORE:
     sta  tempa            ;save current accumulator value in ram
     txa                   ;transfer peprom data from x reg to accumulator
     ldx  tempx            ;recover saved x register value
     sta  prom,x           ;store peprom data in ram
     incx                  ;increment ram address by one
     stx  tempx            ;save new ram address
     clrx                  ;zero the x register
     lda  tempa            ;recover saved accumulator value
     rts                   ;return
*
*
    ORG VECTORS
*
    dw  timer_isr          ;timer overflow service routine
    dw  external_isr       ;external interrupt service routine
    dw  start              ;there is no swi interrupt service routine
    dw  start              ;reset vector






