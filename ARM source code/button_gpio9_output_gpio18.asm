macro delay {
    local .wait
    mov r2,#0x3f0000
    .wait:
        sub r2,#1
        cmp r2,#0
        bne .wait
}

BASE = $3F000000
GPIO_OFFSET = $200000
mov r0, BASE
orr r0, GPIO_OFFSET
mov r1,#1
lsl r1,#24
str r1,[r0,#4]

mov r1,#0
str r1,[r0,#0]
loop$:
ldr r3,[r0,#52]

lsr r3,#9
and r3, #1
cmp r3,#0
bne next
mov r1,$21
lsl r1,#18
str r1,[r0,#28]
delay
b   test

next:
mov r1,$21
lsl r1,#18
str r1,[r0,#40]
delay

test:

b   loop$