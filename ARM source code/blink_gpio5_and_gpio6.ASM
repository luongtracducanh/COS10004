macro delay {
local .wait
mov r2,#0x3F0000
.wait:
        sub r2,#1
        cmp r2,#0
        bne .wait
}

BASE = $3F000000
GPIO_OFFSET = $200000

mov r0,BASE
orr r0, GPIO_OFFSET

mov r1,#1
lsl r1,#15
str r1,[r0,#0]

mov r2,#1
lsl r2,#18
str r2,[r0,#0]

loop$:
mov r1,#1
lsl r1,#5
str r1,[r0,#28]

mov r2,#1
lsl r2,#6
str r2,[r0,#28]
delay

mov r1,#1
lsl r1,#5
str r1,[r0,#40]

mov r2,#1
lsl r2,#6
str r2,[r0,#40] 
delay

b       loop$