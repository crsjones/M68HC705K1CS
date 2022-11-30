
*******************************************************************************
          org   rom               ;program begins at location $0200. IASM05K
                                  ;contains several built-in labels or "tags"
                                  ;with specific values. Most other assemblers
                                  ;do not have this feature and the user would
                                  ;have to first equate the tag to be used to
                                  ;a specific location.
                                  ;ex.) rom equ $0200.
*******************************************************************************
start     lda   #80               ;set bit 7 of port a to a logical 1. (turn
                                  ;LED1 off)
          sta   prta              ;store accumulator to port a
          lda   #0f0              ;load accumulator with hex equivalent of
                                  ;11110000
          sta   ddra              ;define lower four bits of port a as inputs,
                                  ;upper four as outputs
*******************************************************************************
checksw   brset 0,prta,noblink    ;check to see if switch S2 has been pressed
          lda   prta              ;load current value of port a into accumulator
          eor   #80               ;exclusive-or bit 7 of port a (blink LED1)
          sta   prta              ;store new accumulator value to port a
          clrx                    ;zero x-register
loop      clra                    ;this loop is used to slow the flash rate of
          decx                    ;LED1.
          bne   loop              ;
          bra   checksw           ;check for a switch closure
noblink   bset  7,prta            ;turn off LED1
          bra   checksw           ;check for a switch closure
*******************************************************************************
          org   vectors           ;vectors begin at $03F8
          dw    rom               ;there is no timer interrupt service routine
          dw    rom               ;there is no external interrupt service routine
          dw    rom               ;there is no swi interrupt service routine
          dw    start             ;reset vector
