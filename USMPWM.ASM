$nolist
$include 'k1equ.asm'
$list

;Equates for all 705K1 are included but not shown
; in this listing
;
Percent100 EQU   $FF     ;DesiredPWM value for 100% duty
PWM        EQU   PA7     ;PWM output on port A bit 7
;                        ;update the DesiredPWM variable.

           ORG   RAMStart

DesiredPWM RMB   1       ;Desired PWM duty cycle...
; expressed as the numerator of DesiredPWM/255.
; 0 = continuous low     255 = continuous high.

PWMCoarse  RMB   1       ;Number of TOF interrupts...
; before we start to compare PWMFine to value in the TCR.

PWMFine    RMB   1       ;When TCR matches PWMFine,...
;                        ; the PWM is set low.
; PWMFine is derived from the lower 4-bits of DesiredPWM.
; These 4-bits are placed in the upper 4-bits of PWMFine.

VarEnd     EQU   *

;********************************************************
;
           ORG   ROMStart
;
Start      EQU   *
           RSP           ;Reset the stack pointer
           CLR   PORTA   ;Set Port A outputs to all 0's
           LDA   #$FF    ;Make all Port A's pins outputs
           STA   DDRA
;                         Clear out all of RAM
           LDX   #RAMStart ;Point to the start of RAM
ClrLoop    CLR   0,X     ;Clear a byte
           INCX          ;Point to the next location
                         ;Cleared the last location?
           BNE   ClrLoop ;No, Continue to clear RAM

           LDA   #$80    ;Corresponds to 50% (128/255)
           STA   DesiredPWM ;Establish a PWM duty cycle
           LDA   #$1C    ;Clear timer ints...
           STA   TCSR    ;and enable RTIF interrupt
           CLI           ;Enable interrupts
           BRA   *       ;Infinite loop, PWM uses ints

;********************************************************
;RTI sets period. @2MHz & RT1:RT0 = 0:0, period = 8.192ms
;or about 122 Hz
TimerInt   EQU   *
           BRSET TOF,TCSR,TOFInt ;TOF interrupt?
           BRSET RTIF,TCSR,RTIInt ;RTI interrupt?
           RTI

;********************************************************
;TOF interrupt response - Decrement PWMCoarse, when 0...
;Compare PWMFine to TCR. When TCR passes PWMFine clear
;PWM output pin and disable further TOF. RTI re-enables.
;
TOFInt     EQU   *
           DEC   PWMCoarse ;Is PWMCoarse=0?
           BNE   ExitTOF   ;No. Clear TOF and return
TOFInt1    LDA   PWMFine   ;To compare to upper 4 of TCR
CmpMore    CMPA  TCR
           BHI   CmpMore   ;Loop till PWMFine <= TCR
           BCLR  PWM,PORTA ;Set the PWM output low (0V)
           BCLR  TOIE,TCSR ;Disable the TOF Interrupt
ExitTOF    BSET  TOFR,TCSR ;Reset the TOF Interrupt Flag
           RTI             ;Return to the main program

;********************************************************
;RTIF interrupt response - Set PWM out pin high, and
;enable TOF. Make PWMCoarse & PWMFine from DesiredPWM
;
RTIInt     EQU   *
           BSET  RTIFR,TCSR ;Clear the RT Interrupt Flag
           LDA   DesiredPWM ;Get desired PWM level. =0?
           BEQ   RTIInt2    ;Yes. Leave PWM output low
           BSET  PWM,PORTA  ;No. Set PWM output high
           CMPA  #Percent100 ;Desired PWM level 100%?
           BEQ   RTIInt2    ;Yes. Leave PWM output high
           CLRX             ;No. Put upper 4-bits of
           LSLA             ;DesiredPWM into lower 4-bits
           ROLX             ;of A and the lower 4-bits of
           LSLA             ;DesiredPWM into the upper
           ROLX             ;4-bits of x.
           LSLA
           ROLX
           LSLA
           ROLX
           STA   PWMFine    ;Save result into PWMFine.
RTIInt1    STX   PWMCoarse  ;Save result into PWMCoarse.
           BEQ   TOFInt1    ;If PWMCoarse=0, go to 2nd
                            ;half of the TOF routine
           BSET  TOFR,TCSR  ;Clear Timer Overflow Flag
           BSET  TOIE,TCSR  ;re-enable the TOF interrupt
RTIInt2    RTI              ;return from RTIF interrupt


           ORG   Vectors    ;interrupt/reset vectors.

           FDB   TimerInt   ;timer interrupt routine.
           FDB   Start      ;IRQ vector (not used)
           FDB   Start      ;SWI vector (not used)
           FDB   Start      ;Reset vector.
