;GPIO.asm
GPIO_OFFSET = $200000
SETUP_LED:
;param r0=BASE
orr r0,GPIO_OFFSET
mov r1,#1
lsl r1,#24
str r1,[r0,#4] ;set GPIO18 to output
bx lr

FLASH:
;param r0=BASE
;need BASE for timer, so copy to r2 here
mov r2,r0
;param r1 = number of flashes
orr r0,GPIO_OFFSET
mov r7,r1
loop$:
 mov r1,#1
 lsl r1,#18
 str r1,[r0,#28] ;turn LED on
  push {r0,r1,r7,lr} ;r0,r1,r7 in use push and then set parameters
  mov r0,BASE
  mov r1,$0F0000
  bl Delay
  pop {r0,r1,r7,lr}
  mov r1,#1
  lsl r1,#18
  str r1,[r0,#40] ;turn LED off
  push {r0,r1,r7,lr} ;r0,r1,r7 in use push and then set parameters
  mov r0,BASE
  mov r1,$0F0000
  bl Delay
  pop {r0,r1,r7,lr}
sub r7,r7,#1
cmp r7,#0
bgt loop$ ;end of outer loop. Runs r7 times
bx lr
