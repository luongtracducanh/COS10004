;flash red LED once
FLASH:
GPIO_OFFSET = $200000
;mov sp,$8000


mov r0,BASE
orr r0,GPIO_OFFSET ;Base address of GPIO
mov r1,#1
lsl r1,#15 ;B+
str r1,[r0,#12] ;enable output

mov r1,#1
lsl r1,#3

 str r1,[r0,#44] ;Turn off LED
 ;new timer
TIMER_OFFSET = $3000
;TIMER_MICROSECONDS = 524288 ; $0080000 ;0.524288 s
mov r3,BASE
orr r3,TIMER_OFFSET ;store base address of timer (r3)
mov r4,$70000
orr r4,$0A100
orr r4,$00020	;TIMER_MICROSECONDS = 500,000
  ;store delay (r4)
 ldrd r6,r7,[r3,#4] 
 mov r5,r6 ;store starttime (r5)(=currenttime (r6))
 floopt1:
  ldrd r6,r7,[r3,#4] ;read currenttime (r6)
  sub r8,r6,r5	;remainingtime (8)= currenttime (r6) - starttime (r5)
  cmp  r8,r4  ;compare remainingtime (r8), delay (r4)
  bls floopt1 ;loop if LE (reaminingtime <= delay)
 str r1,[r0,#32]  ;turn on LED
 ;re-use timer
 ldrd r6,r7,[r3,#4] 
 mov r5,r6 ;store starttime (r5)(=currenttime (r6))
 floopt2:
  ldrd r6,r7,[r3,#4] ;read currenttime (r6)
  sub r8,r6,r5	;remainingtime (8)= currenttime (r6) - starttime (r5)
  cmp  r8,r4  ;compare remainingtime (r8), delay (r4)
  bls floopt2 ;loop if LE (reaminingtime <= delay)

 bx lr