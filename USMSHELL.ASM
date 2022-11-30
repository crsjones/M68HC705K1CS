$base 10t
*******************************************************
* Equates for MC68HC705K1 MCU
* Use bit names without a dot in BSET..BRCLR
* Use bit name preceded by a dot in expressions such as
*  #.ELAT+.EPGM to form a bit mask
*******************************************************
PORTA   EQU    $00      ;I/O port A
PA7     EQU    7        ;Bit #7 of port A
PA6     EQU    6        ;Bit #6 of port A
PA5     EQU    5        ;Bit #5 of port A
PA4     EQU    4        ;Bit #4 of port A
PA3     EQU    3        ;Bit #3 of port A
PA2     EQU    2        ;Bit #2 of port A
PA1     EQU    1        ;Bit #1 of port A
PA0     EQU    0        ;Bit #0 of port A
PA7.    EQU    $80      ;Bit position PA7
PA6.    EQU    $40      ;Bit position PA6
PA5.    EQU    $20      ;Bit position PA5
PA4.    EQU    $10      ;Bit position PA4
PA3.    EQU    $08      ;Bit position PA3
PA2.    EQU    $04      ;Bit position PA2
PA1.    EQU    $02      ;Bit position PA1
PA0.    EQU    $01      ;Bit position PA0

PORTB   EQU    $01      ;I/O port B
PB7     EQU    7        ;Bit #7 of port B
PB6     EQU    6        ;Bit #6 of port B
PB7.    EQU    $80      ;Bit position PB7
PB6.    EQU    $40      ;Bit position PB6

DDRA    EQU    $04      ;Data direction for port A
DDRA7   EQU    7        ;Bit #7 of port A DDR
DDRA6   EQU    6        ;Bit #6 of port A DDR
DDRA5   EQU    5        ;Bit #5 of port A DDR
DDRA4   EQU    4        ;Bit #4 of port A DDR
DDRA3   EQU    3        ;Bit #3 of port A DDR
DDRA2   EQU    2        ;Bit #2 of port A DDR
DDRA1   EQU    1        ;Bit #1 of port A DDR
DDRA0   EQU    0        ;Bit #0 of port A DDR
DDRA7.  EQU    $80      ;Bit position DDRA7
DDRA6.  EQU    $40      ;Bit position DDRA6
DDRA5.  EQU    $20      ;Bit position DDRA5
DDRA4.  EQU    $10      ;Bit position DDRA4
DDRA3.  EQU    $08      ;Bit position DDRA3
DDRA2.  EQU    $04      ;Bit position DDRA2
DDRA1.  EQU    $02      ;Bit position DDRA1
DDRA0.  EQU    $01      ;Bit position DDRA0

DDRB    EQU    $05      ;Data direction for port B
DDRB7   EQU    7        ;Bit #7 of port B DDR
DDRB6   EQU    6        ;Bit #6 of port B DDR
DDRB7.  EQU    $80      ;Bit position DDRB7
DDRB6.  EQU    $40      ;Bit position DDRB6

TCSR    EQU    $08      ;Timer status & control reg
TOF     EQU    7        ;Timer overflow flag
RTIF    EQU    6        ;Real time interrupt flag
TOIE    EQU    5        ;TOF interrupt enable
RTIE    EQU    4        ;RTI interrupt enable
TOFR    EQU    3        ;TOF flag reset
RTIFR   EQU    2        ;RTIF flag reset
RT1     EQU    1        ;RTI rate select bit 1
RT0     EQU    0        ;RTI rate select bit 0
TOF.    EQU    $80      ;Bit position TOF
RTIF.   EQU    $40      ;Bit position RTIF
TOIE.   EQU    $20      ;Bit position TOIE
RTIE.   EQU    $10      ;Bit position RTIE
TOFR.   EQU    $08      ;Bit position TOFR
RTIFR.  EQU    $04      ;Bit position RTIFR
RT1.    EQU    $02      ;Bit position RT1
RT0.    EQU    $01      ;Bit position RT0

TCR     EQU    $09      ;Timer counter register

ISCR    EQU    $0A      ;IRQ status & control reg
IRQE    EQU    7        ;IRQ edge/edge-level
IRQF    EQU    3        ;External interrupt flag
IRQR    EQU    1        ;IRQF flag reset

PEBSR   EQU    $0E      ;PEPROM bit select register
PEB7    EQU    7        ;Select PEPROM bit 7
PEB6    EQU    6        ;Select PEPROM bit 6
PEB5    EQU    5        ;Select PEPROM bit 5
PEB4    EQU    4        ;Select PEPROM bit 4
PEB3    EQU    3        ;Select PEPROM bit 3
PEB2    EQU    2        ;Select PEPROM bit 2
PEB1    EQU    1        ;Select PEPROM bit 1
PEB0    EQU    0        ;Select PEPROM bit 0
PEB7.   EQU    $80      ;Bit position PEB7
PEB6.   EQU    $40      ;Bit position PEB6
PEB5.   EQU    $20      ;Bit position PEB5
PEB4.   EQU    $10      ;Bit position PEB4
PEB3.   EQU    $08      ;Bit position PEB3
PEB2.   EQU    $04      ;Bit position PEB2
PEB1.   EQU    $02      ;Bit position PEB1
PEB0.   EQU    $01      ;Bit position PEB0

PESCR   EQU    $0F      ;PEPROM status & control reg
PEDATA  EQU    7        ;PEPROM data
PEPGM   EQU    5        ;PEPROM program control
PEPRZF  EQU    0        ;PEPROM row zero flag
PEDATA. EQU    $80      ;Bit position PEDATA
PEPGM.  EQU    $20      ;Bit position PEPGM
PEPRZF. EQU    $01      ;Bit position PEPRZF

PDRA    EQU    $10      ;Pulldown register for port A
PDIA7   EQU    7        ;Pulldown inhibit for PA7
PDIA6   EQU    6        ;Pulldown inhibit for PA6
PDIA5   EQU    5        ;Pulldown inhibit for PA5
PDIA4   EQU    4        ;Pulldown inhibit for PA4
PDIA3   EQU    3        ;Pulldown inhibit for PA3
PDIA2   EQU    2        ;Pulldown inhibit for PA2
PDIA1   EQU    1        ;Pulldown inhibit for PA1
PDIA0   EQU    0        ;Pulldown inhibit for PA0
PDIA7.  EQU    $80      ;Bit position PDIA7
PDIA6.  EQU    $40      ;Bit position PDIA6
PDIA5.  EQU    $20      ;Bit position PDIA5
PDIA4.  EQU    $10      ;Bit position PDIA4
PDIA3.  EQU    $08      ;Bit position PDIA3
PDIA2.  EQU    $04      ;Bit position PDIA2
PDIA1.  EQU    $02      ;Bit position PDIA1
PDIA0.  EQU    $01      ;Bit position PDIA0

PDRB    EQU    $11      ;Pulldown register for port B
PDIB7   EQU    7        ;Pulldown inhibit for PB7
PDIB6   EQU    6        ;Pulldown inhibit for PB6
PDIB7.  EQU    $80      ;Bit position PDIB7
PDIB6.  EQU    $40      ;Bit position PDIB6

MOR     EQU    $17      ;Mask option register
SWPDI   EQU    7        ;Software pulldown inhibit
PIN3    EQU    6        ;3-pin RC oscillator
RC      EQU    5        ;RC oscillator
SWAIT   EQU    4        ;STOP coversion to wait
LVRE    EQU    3        ;Low voltage reset enable
PIRQ    EQU    2        ;Port A IRQ enable
LEVEL   EQU    1        ;Edge & level/ edge-only
COPEN   EQU    0        ;COP watchdog enable
SWPDI.  EQU    $80      ;Bit position SWPDI
PIN3.   EQU    $40      ;Bit position PIN3
RC.     EQU    $20      ;Bit position RC
SWAIT.  EQU    $10      ;Bit position SWAIT
LVRE.   EQU    $08      ;Bit position LVRE
PIRQ.   EQU    $04      ;Bit position PIRQ
LEVEL.  EQU    $02      ;Bit position LEVEL
COPEN.  EQU    $01      ;Bit position COPEN

EPROG   EQU    $18      ;EPROM programming register
ELAT    EQU    2        ;EPROM latch control
MPGM    EQU    1        ;MOR programming control
EPGM    EQU    0        ;EPROM program control
ELAT.   EQU    $04      ;Bit position ELAT
MPGM.   EQU    $02      ;Bit position MPGM
EPGM.   EQU    $01      ;Bit position EPGM

COPR    EQU    $03F0    ;COP watchdog reset register
COPC    EQU    0        ;COP watchdog clear
COPC.   EQU    $01      ;Bit position COPC

* Application specific equates
LED     EQU    PA7      ;LED ON when PA7 is low (0)
LED.    EQU    PA7.     ;LED bit position
SW      EQU    PA0      ;Switch on PA0, closed=high (1)
SW.     EQU    PA0.     ;Switch bit position

*******************************************************
* Put program variables here (use RMBs)
*******************************************************
        ORG    $00E0    ;Start of 705K1 RAM

RTIFs   RMB    1        ;3 RTIFs/TIC (3-0)
TIC     RMB    1        ;10 TICs make 1 TOC (10-0)
                        ;MSB=1 means RTIFs rolled over
TOC     RMB    1        ;1 TOC=10*96.24ms= about 1 sec

*******************************************************
* Program area starts here
*******************************************************
        ORG    $0200    ;Start of 705K1 EPROM

* First initialize any control registers and variables

START   LDA    #LED.    ;Configure and turn off LED
        STA    PORTA    ;Turns off LED
        STA    DDRA     ;Makes LED pin an output
        LDA    #{RTIFR.+RTIE.+RT1.}
        STA    TCSR     ;To clear and enable RTIF
                        ;and set RTI rate for 32.8 ms
        LDA    #3       ;RTIFs counts 3->0
        STA    RTIFs    ;Reset TOFS count
        CLR    TIC      ;Initial value for TIC
        CLR    TOC      ;Initial value for TOC
        CLI             ;clear I-mask
        CLRX            ;initialize x-register for proper ICS05K operation

*******************************************************
* MAIN - Beginning of main program loop
*       Loop is executed once every 100ms (98.4ms)
*       A pass through all major task routines takes
*       less than 100mS and then time is wasted until
*       MSB of TIC set (every 3 RTIFs = 98.4ms).
*       At each RTIF interrupt, RTIF cleared & RTIFs
*       gets decremented (3-0). When RTIFs=0, MSB of
*       TIC gets set and RTIFs is set back to 3.
*       (3*32.8/RTIF = 98.4ms).
*
*       The variable TIC keeps track of 100mS periods
*       When TIC increments from 9 to 10 it is cleared
*       to 0 and TOC is incremented.
*******************************************************
MAIN    BRCLR  7,TIC,MAIN ;Loop here till TIC edge
        LDA    TIC   ;Get current TIC value
        AND    #$0F  ;Clears MSB
        INCA         ;TIC=TIC+1
        STA    TIC   ;Update TIC
        CMP    #10   ;10th TIC ?
        BNE    ARNC1 ;If not, skip next clear
        CLR    TIC   ;Clear TIC on 10th
ARNC1   EQU    *     ;
* End of synchronization to 100mS TIC; Run main tasks
*  & branch back to MAIN within 100mS.  Sync OK as
*  long no 2 consecutive passes take more than 196.8mS

        JSR     TIME    ;Update TOCs

        JSR     BLINK   ;Blink LED

* Other main tasks would go here

        BRA     MAIN    ;Back to Top for next TIC

** END of Main Loop ***********************************

*******************************************************
* TIME - Update TOCs
*  If TIC = 0, increment 0->59
*  If TIC not = 0, just skip whole routine
*******************************************************
TIME    EQU  *      ;Update TOCs
        TST  TIC    ;Check for TIC=zero
        BNE  XTIME  ;If not; just exit
        INC  TOC    ;TOC=TOC+1
        LDA  #60
        CMP  TOC    ;Did TOC -> 60 ?
        BNE  XTIME  ;If not; just exit
        CLR  TOC    ;TOCs rollover
XTIME   RTS         ;Return from TIME

*******************************************************
* BLINK - Update LED
*  If TOC is even, light LED
*     else turn off LED
*******************************************************
BLINK   EQU     *         ;Update LED
        LDA     TOC       ;If even, LSB will be zero
        LSRA              ;Shift LSB to carry
        BCS     LEDOFF    ;If not, turn off LED
        BCLR    LED,PORTA ;Turn on LED
        BRA     XBLINK    ;Then exit
LEDOFF  BSET    LED,PORTA ;Turn off LED
XBLINK  RTS               ;Return from BLINK

*******************************************************
* RTIF interrupt service routine
*******************************************************
RTICNT  DEC    RTIFs    ;On each RTIF decrement RTIFs
        BNE    ENDTOF   ;Done if RTIFs not 0
        LDA    #3       ;RTIFs counts 3->0
        STA    RTIFs    ;Reset TOFS count
        BSET   7,TIC    ;Set MSB as a flag to MAIN
ENDTOF  BSET   RTIFR,TCSR ;Clear RTIF flag
AnRTI   RTI             ;Return from RTIF interrupt

UNUSED  EQU    AnRTI    ;Use RTI at AnRTI for unused
                        ;interrupts to just return

*******************************************************
* Interrupt & reset vectors
*******************************************************
        ORG    $03F8    ;Start of vector area

TIMVEC  FDB    RTICNT   ;Count RTIFs 3/TIC
IRQVEC  FDB    UNUSED   ;Change if vector used
SWIVEC  FDB    UNUSED   ;Change if vector used
RESETV  FDB    START    ;Beginning of program on reset

