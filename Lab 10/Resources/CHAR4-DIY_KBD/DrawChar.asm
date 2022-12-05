  DrawChar:
    ldr r6,[r5],4 ; Load Font Text Character 1/2 Row
    str r6,[r0],4 ; Store Font Text Character 1/2 Row To Frame Buffer
    ldr r6,[r5],4 ; Load Font Text Character 1/2 Row
    str r6,[r0],4 ; Store Font Text Character 1/2 Row To Frame Buffer
    add r0,SCREEN_X ; Jump Down 1 Scanline
    sub r0,CHAR_X ; Jump Back 1 Char
    subs r4,1 ; Decrement Character Row Counter
    bne DrawChar ; IF (Character Row Counter != 0) ;DrawChar
bx lr