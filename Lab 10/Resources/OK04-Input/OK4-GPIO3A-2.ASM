format binary as 'img'  ;must be first
mov sp,$1000 ;initialise stack pointer
;momentary switch swaps LEDs
org $8000
;GPIOs:
;pin 17: +3.3v
;pin 19: GPI10  (input)

; outputs:
;pin 12: GPIO18 (LED 1)
;pin 14: GPIO23 (LED 2)

;NC: pin 19 not connected (GPIO 10)
;Pull-up: pin 19 connected to +3.3V (pin 17)


BASE = $FE000000 ; Swap with $3F000000 for Pi 2/ 3B/ 3B+
GPIO_OFFSET = $200000
mov r0,BASE
orr r0,GPIO_OFFSET ;Base address of GPIO
ldr r1,[r0,#4] ;read function register for GPIO 10 - 19
bic r1,r1, #7 ;   ; #27  ;bit clear  27 = 9 * 3    = read access
str r1,[r0,#4];10 input

;set up outputs
ldr r10,[r0,#4]  ; LED 1 (GPIO18)
orr r10, $1000000  ;set bit 24
str r10,[r0,#4] ; GPIO18 output

ldr r2,[r0,#8]    ; LED 2 (GPIO23)
orr r2, $200  ;set bit 9
str r2,[r0,#8] ; GPIO23 output

;activate LED 1
mov r2,#1
lsl r2,#18  ;bit 18 to write to GPIO18
;disable LED 2
mov r10,#1
lsl r10,#23   ;bit 23 to write to GPIO23

;poll GPIO10 and swap LEDS if high
loop$:
;read first block of GPIOs
ldr r9,[r0,#52] ;read gpios 0-31
tst r9,#1024  ; use tst to check bit 10
bne led2 ;if ==0
;else LED 1
str r2,[r0,#28] ;Turn on LED 1
b cont
led2:
str r10,[r0,#28] ;Turn on LED 2
cont:

;call timer
push {r0-r3}
mov r0,BASE
mov r1,$70000
orr r1,$0A100
orr r1,$00020   ;TIMER_MICROSECONDS = 500,000
bl Delay
pop {r0-r3}

ldr r9,[r0,#52] ;read gpios 0-31
tst r9,#1024  ; use tst to check bit 10
bne led2_2 ; if ==0
;else
str r2,[r0,#40] ;Turn off LED 1
b cont2
led2_2:
str r10,[r0,#40] ;Turn off LED 2
cont2:

;call timer
push {r0-r3}
mov r0,BASE
mov r1,$70000
orr r1,$0A100
orr r1,$00020   ;TIMER_MICROSECONDS = 500,000
bl Delay
pop {r0-r3}

b loop$

include "timer2_2Param.asm"
