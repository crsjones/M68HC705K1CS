;
;       MC68HC05K1 Equates
;
PORTA   equ     $00     ; Port A byte address
PA0     equ     0       ; Port A bit 0
PA1     equ     1       ; Port A bit 1
PA2     equ     2       ; Port A bit 2
PA3     equ     3       ; Port A bit 3
PA4     equ     4       ; Port A bit 4
PA5     equ     5       ; Port A bit 5
PA6     equ     6       ; Port A bit 6
PA7     equ     7       ; Port A bit 7
;
PORTB   equ     $01     ; Port B byte address
PB0     equ     0       ; Port B bit 0
PB1     equ     1       ; Port B bit 1
;
DDRA    equ     $04     ; Port A Data Direction Register
;
DDRB    equ     $05     ; Port B Data Direction Register
;
TCSR    equ     $08     ; Timer Status and Control Register
RT0     equ     0       ; Real-Time Interrupt Rate Select bit 0
RT1     equ     1       ; Real-Time Interrupt Rate Select bit 1
RTIFR   equ     2       ; Real-Time Interrupt Flag Reset
TOFR    equ     3       ; Timer Overflow Flag Reset
RTIE    equ     4       ; Real-Time Interrupt Enable
TOIE    equ     5       ; Timer Overflow Interrupt Enable
RTIF    equ     6       ; Real-Time Interrupt Flag
TOF     equ     7       ; Timer Overflow Flag
;
TCR     equ     $09     ; Timer-Counter Register
;
ISCR    equ     $0A     ; Interrupt Status and Control Register
IRQR    equ     1       ; Interrupt Request Reset
IRQF    equ     3       ; External Interrupt Request Flag
IRQE    equ     7       ; External Interrupt Request Enable
;
PEBSR   equ     $0E     ; Personality EPROM Bit Select Register
;
PESCR   equ     $0F     ; Personality EPROM Status and Control Register
PEPRZF  equ     0       ; Personality EPROM Row Zero Flag
PEPGM   equ     5       ; Personality EPROM Program Control
PEDATA  equ     7       ; Personality EPROM Data
;
PDRA    equ     $10     ; Pull-Down Register Port A (Write-Only)
;
PDRB    equ     $11     ; Pull-Down Register Port B (Write-Only)
;
MOR     equ     $17     ; Mask Option Register (EPROM byte)
COPEN   equ     0       ; COP Watchdog Enable
LEVEL   equ     1       ; External Interrupt Sensitivity
PIRQ    equ     2       ; Port A Interrupt Function Enable
LVRE    equ     3       ; Low Voltage Reset Enable
SWAIT   equ     4       ; STOP conversion to WAIT
RC      equ     5       ; RC Oscillator select
PIN3    equ     6       ; Three-Pin RC Oscillator Select
SWPDI   equ     7       ; Software Pull-Down Inhibit
;
EPROG   equ     $18     ; EPROM Programming Control Register
EPGM    equ     0       ; EPROM Programming
MPGM    equ     1       ; Mask Option Register Programming
ELAT    equ     2       ; EPROM Bus Latch
;
COPR    equ     $3F0    ; COP Reset Register
;
;
RAMStart        equ     $00E0   ; Start of on chip RAM
ROMStart        equ     $0200   ; Start of on chip ROM/EPROM
ROMEnd  equ     $03EF   ; End of on chip ROM/EPROM
Vectors equ     $03F8   ; Start of Reset/Interrupt vectors
