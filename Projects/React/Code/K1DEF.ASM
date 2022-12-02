;----------------------
;MC68HC05K1 Definitions
;----------------------
PORTA   equ     $00     ;Port A data register
PA0     equ     0       ;Port A bit 0
PA1     equ     1       ;Port A bit 1
PA2     equ     2       ;Port A bit 2
PA3     equ     3       ;Port A bit 3
PA4     equ     4       ;Port A bit 4
PA5     equ     5       ;Port A bit 5
PA6     equ     6       ;Port A bit 6
PA7     equ     7       ;Port A bit 7
PA0.    equ     $01     ;Bit position PA0
PA1.    equ     $02     ;Bit position PA1
PA2.    equ     $04     ;Bit position PA2
PA3.    equ     $08     ;Bit position PA3
PA4.    equ     $10     ;Bit position PA4
PA5.    equ     $20     ;Bit position PA5
PA6.    equ     $40     ;Bit position PA6
PA7.    equ     $80     ;Bit position PA7
;
PORTB   equ     $01     ;Port B data register
PB0     equ     0       ;Port B bit 0
PB1     equ     1       ;Port B bit 1
PB0.    equ     $01     ;Bit position PB0
PB1.    equ     $02     ;Bit position PB1
;
DDRA    equ     $04     ;Port A Data Direction Register
DDRA0   equ     0       ;Port A DDR bit 0
DDRA1   equ     1       ;Port A DDR bit 1
DDRA2   equ     2       ;Port A DDR bit 2
DDRA3   equ     3       ;Port A DDR bit 3
DDRA4   equ     4       ;Port A DDR bit 4
DDRA5   equ     5       ;Port A DDR bit 5
DDRA6   equ     6       ;Port A DDR bit 6
DDRA7   equ     7       ;Port A DDR bit 7
DDRA0.  equ     $01     ;Bit position DDRA0
DDRA1.  equ     $02     ;Bit position DDRA1
DDRA2.  equ     $04     ;Bit position DDRA2
DDRA3.  equ     $08     ;Bit position DDRA3
DDRA4.  equ     $10     ;Bit position DDRA4
DDRA5.  equ     $20     ;Bit position DDRA5
DDRA6.  equ     $40     ;Bit position DDRA6
DDRA7.  equ     $80     ;Bit position DDRA7
;
DDRB    equ     $05     ;Port B Data Direction Register
DDRB0   equ     0       ;Port B DDR bit 0
DDRB1   equ     1       ;Port B DDR bit 1
DDRB0.  equ     $01     ;Bit position DDRB0
DDRB1.  equ     $02     ;Bit position DDRB1
;
TCSR    equ     $08     ;Timer Status and Control Register
RT0     equ     0       ;Real-Time Interrupt Rate Select bit 0
RT1     equ     1       ;Real-Time Interrupt Rate Select bit 1
RTIFR   equ     2       ;Real-Time Interrupt Flag Reset
TOFR    equ     3       ;Timer Overflow Flag Reset
RTIE    equ     4       ;Real-Time Interrupt Enable
TOIE    equ     5       ;Timer Overflow Interrupt Enable
RTIF    equ     6       ;Real-Time Interrupt Flag
TOF     equ     7       ;Timer Overflow Flag
RT0.    equ     $01     ;Real-Time Interrupt Rate Select bit 0
RT1.    equ     $02     ;Real-Time Interrupt Rate Select bit 1
RTIFR.  equ     $04     ;Real-Time Interrupt Flag Reset
TOFR.   equ     $08     ;Timer Overflow Flag Reset
RTIE.   equ     $10     ;Real-Time Interrupt Enable
TOIE.   equ     $20     ;Timer Overflow Interrupt Enable
RTIF.   equ     $40     ;Real-Time Interrupt Flag
TOF.    equ     $80     ;Timer Overflow Flag
;
TCR     equ     $09     ;Timer Counter Register
;
ISCR    equ     $0A     ;Interrupt Status and Control Register
IRQR    equ     1       ;Interrupt Request Reset
IRQF    equ     3       ;External Interrupt Request Flag
IRQE    equ     7       ;External Interrupt Request Enable
;
PEBSR   equ     $0E     ;Personality EPROM Bit Select Register
PEB0    equ     0       ;Select PEPROM bit 0
PEB1    equ     1       ;Select PEPROM bit 1
PEB2    equ     2       ;Select PEPROM bit 2
PEB3    equ     3       ;Select PEPROM bit 3
PEB4    equ     4       ;Select PEPROM bit 4
PEB5    equ     5       ;Select PEPROM bit 5
PEB6    equ     6       ;Select PEPROM bit 6
PEB7    equ     7       ;Select PEPROM bit 7
PEB0.   equ     $01     ;Bit position PEB0
PEB1.   equ     $02     ;Bit position PEB1
PEB2.   equ     $04     ;Bit position PEB2
PEB3.   equ     $08     ;Bit position PEB3
PEB4.   equ     $10     ;Bit position PEB4
PEB5.   equ     $20     ;Bit position PEB5
PEB6.   equ     $40     ;Bit position PEB6
PEB7.   equ     $80     ;Bit position PEB7
;
PESCR   equ     $0F     ;Personality EPROM Status and Control Register
PEPRZF  equ     0       ;Personality EPROM Row Zero Flag
PEPGM   equ     5       ;Personality EPROM Program Control
PEDATA  equ     7       ;Personality EPROM Data
PEPRZF. equ     $01     ;Bit position PE Row Zero Flag
PEPGM.  equ     $20     ;Bit position PE Program
PEDATA. equ     $80     ;Bit position PE Data
;
PDRA    equ     $10     ;Pull-Down Register Port A (Write-Only)
PDIA0   equ     0       ;Pulldown inhibit for PA0
PDIA1   equ     1       ;Pulldown inhibit for PA1
PDIA2   equ     2       ;Pulldown inhibit for PA2
PDIA3   equ     3       ;Pulldown inhibit for PA3
PDIA4   equ     4       ;Pulldown inhibit for PA4
PDIA5   equ     5       ;Pulldown inhibit for PA5
PDIA6   equ     6       ;Pulldown inhibit for PA6
PDIA7   equ     7       ;Pulldown inhibit for PA7
PDIA0.  equ     $01     ;Bit position PDIA0
PDIA1.  equ     $02     ;Bit position PDIA1
PDIA2.  equ     $04     ;Bit position PDIA2
PDIA3.  equ     $08     ;Bit position PDIA3
PDIA4.  equ     $10     ;Bit position PDIA4
PDIA5.  equ     $20     ;Bit position PDIA5
PDIA6.  equ     $40     ;Bit position PDIA6
PDIA7.  equ     $80     ;Bit position PDIA7
;
PDRB    equ     $11     ;Pull-Down Register Port B (Write-Only)
PDIB0   equ     0       ;Pulldown inhibit for PB0
PDIB1   equ     1       ;Pulldown inhibit for PB1
PDIB2   equ     2       ;Pulldown inhibit for PB2
PDIB3   equ     3       ;Pulldown inhibit for PB3
PDIB4   equ     4       ;Pulldown inhibit for PB4
PDIB5   equ     5       ;Pulldown inhibit for PB5
PDIB6   equ     6       ;Pulldown inhibit for PB6
PDIB7   equ     7       ;Pulldown inhibit for PB7
PDIB0.  equ     $01     ;Bit position PDIB0
PDIB1.  equ     $02     ;Bit position PDIB1
PDIB2.  equ     $04     ;Bit position PDIB2
PDIB3.  equ     $08     ;Bit position PDIB3
PDIB4.  equ     $10     ;Bit position PDIB4
PDIB5.  equ     $20     ;Bit position PDIB5
PDIB6.  equ     $40     ;Bit position PDIB6
PDIB7.  equ     $80     ;Bit position PDIB7
;
MOR     equ     $17     ;Mask Option Register (EPROM byte)
COPEN   equ     0       ;COP Watchdog Enable
LEVEL   equ     1       ;External Interrupt Sensitivity
PIRQ    equ     2       ;Port A Interrupt Function Enable
LVRE    equ     3       ;Low Voltage Reset Enable
SWAIT   equ     4       ;STOP conversion to WAIT
RC      equ     5       ;RC Oscillator select
PIN3    equ     6       ;Three-Pin RC Oscillator Select
SWPDI   equ     7       ;Software Pull-Down Inhibit
COPEN.  equ     $01     ;Bit position COPEN
LEVEL.  equ     $02     ;Bit position LEVEL
PIRQ.   equ     $04     ;Bit position PIRQ
LVRE.   equ     $08     ;Bit position LVRE
SWAIT.  equ     $10     ;Bit position SWAIT
RC.     equ     $20     ;Bit position RC
PIN3.   equ     $40     ;Bit position PIN3
SWPDI.  equ     $80     ;Bit position SWPDI
;
EPROG   equ     $18     ;EPROM Programming Control Register
EPGM    equ     0       ;EPROM Programming
MPGM    equ     1       ;Mask Option Register Programming
ELAT    equ     2       ;EPROM Bus Latch
EPGM.   equ     $01     ;Bit position EPGM
MPGM.   equ     $02     ;Bit position MPGM
ELAT.   equ     $04     ;Bit position ELAT
;
COPR    equ     $03F0   ;COP Reset Register
COPC    equ     0       ;COP watchdog clear
COPC.   equ     $01     ;bit position COPC
;
ramstart        equ     $00E0   ;Start of on chip RAM
romstart        equ     $0200   ;Start of on chip ROM/EPROM
romend  equ     $03EF   ;End of on chip ROM/EPROM
vectors equ     $03F8   ;Start of Reset/Interrupt vectors
$nolist
