*******************************************************
* Simple 68HC05 Program Example                       *
* Read state of switch at port A bit-0; 1=closed      *
* When sw. closes, light LED for about 1 sec; LED on  *
* when port A bit-7 = 0. Wait for sw release,         *
* then repeat. Debounce sw 50mS on & off              *
* NOTE: Timing based on instruction execution times   *
*  If using a simulator or crystal less than 4MHz,    *
*  this routine will run slower than intended         *
*******************************************************
$BASE   10T             ;Used for iASM (commented out)

PORTA   EQU     $00     ;Direct address of port A
DDRA    EQU     $04     ;Data direction control, port A
TEMP1   EQU     $E0     ;One byte temp storage location

        ORG     $0200   ;Program will start at $0200

INIT    LDA     #$80    ;Begin initialization
        STA     PORTA   ;So LED will be off
        STA     DDRA    ;Set port A bit-7 as output
* Rest of port A is configured as inputs

TOP     LDA     PORTA   ;Read sw at LSB of Port A
        AND     #$01    ;To test bit-0
        BEQ     TOP     ;Loop till Bit-0 = 1
        JSR     DLY50   ;Delay about 50 mS to debounce
        BCLR    7,PORTA ;Turn on LED (bit-7 to zero)
        LDA     #20     ;Decimal 20 assembles to $14
DLYLP   JSR     DLY50   ;Delay 50 mS
        DECA            ;Loop counter for 20 loops
        BNE     DLYLP   ;20 times (20-19,19-18,.1-0)
        BSET    7,PORTA ;Turn LED back off
OFFLP   BRSET   0,PORTA,OFFLP ;Loop here till sw off
        JSR     DLY50   ;Debounce release
        BRA     TOP     ;Look for next sw closure

***
* DLY50 - Subroutine to delay ~50mS
* Save original accumulator value
* but X will always be zero on return
***

DLY50   STA     TEMP1   ;Save accumulator in RAM
        LDA     #65     ;Do outer loop 65 times
OUTLP   CLRX            ;X used as inner loop count
INNRLP  DECX            ;0-FF, FF-FE,...1-0 256 loops
        BNE     INNRLP  ;6cyc*256*1ÊS/cyc = 1.536mS
        DECA            ;65-64, 64-63,...1-0
        BNE     OUTLP   ;1545cyc*65*500ns/cyc=50.212mS
        LDA     TEMP1   ;Recover saved Accumulator val
        RTS             ;Return

        ORG     $03FE   ;Vector area
        FDB     TOP     ;Reset vector for ICS05
