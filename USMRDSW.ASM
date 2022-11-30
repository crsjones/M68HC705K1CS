
*********************************************

PORTA   EQU     $00     ;Direct address of port A

        ORG     $0200   ;Program will start at $0200

TOP1    LDA     PORTA   ;Read sw at LSB of Port A
        AND     #$01    ;To test bit-0
        BEQ     TOP1    ;Loop till Bit-0 = 1

TOP2    BRCLR   0,PORTA,TOP2 ;Loop here till sw ON

TOP3    LDA     PORTA   ;Read sw at LSB of Port A
        LSRA            ;Bit-0 shifts to carry
        BCC     TOP3    ;Loop till switch ON

        LDA     #$01    ;1 in LSB
TOP4    BIT     PORTA   ;To test sw at bit-0
        BEQ     TOP4    ;Loop till switch ON


        BRA     TOP1

