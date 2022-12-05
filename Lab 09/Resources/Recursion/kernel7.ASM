mov r1,#4 ;input
mov sp,$1000 ;make room on the stack
mov r0,r1
bl FACTORIAL
mov r7,r0 ;store answer

BASE = $FE000000 ;RP4
;GPIO_SETUP
mov r0,BASE

bl SETUP_LED

mov r0,BASE
mov r1,r7
bl FLASH

wait:
b wait
include "timer2_2Param.asm"
include "factorialj.asm"
include "GPIO.asm"
