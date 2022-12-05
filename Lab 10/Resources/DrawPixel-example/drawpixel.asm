;FILE DrawPixel.asm
;author: JHH for Comp Syst 2015
;version 2 - handles different values of BITS_PER_PIXEL
drawpixel:
   ;paramesters:
   ;r0 = screen memory address incl channel number
   ;r1 = x
   ;r2 = y
   ;r3 = colour (16 bit RGB)
   ;assume BITS_PER_PIXEL, SCREEN_X are shared constants
   ;(they're not, but they are global pointers to values)
   ;r8, r9 are temp registers (because we can't mul a value; only a register)

   ;calculate x term  (x * BITS_PER_PIXEL  / BITS PER BYTE)
   mov r8,r1   ;x
   mov r9, BITS_PER_PIXEL   ;*BITS_PER_PIXEL (16)
   mul r8,r9
   lsr r8,#3   ;/8 (bits per byte)
   add r0,r8   ;add x term

   ;calc y term (y * SCREEN_X * BITS_PER_PIXEL / BITS PER BYTE)
   mov r8,SCREEN_X ;640
   mul r8,r2  ;* y
   mul r8,r9  ;*BITS_PER_PIXEL
   lsr r8,#3  ;/8 bits per byte
   add r0,r8   ;add y term

  ;r3 is what we want to write
 cmp r9,#8; if BITS_PER_PIXEL == 8
 beq dp_eight
  cmp r9,#16;
  beq dp_sixteen
 ;assume 32
  str r6,[r0]  ;for 32-bit colour
  b dp_endif
dp_sixteen:
  strh r3,[r0]	;copy low bytes (Half) to r0
  b dp_endif
dp_eight:
  strb r6,[r0]	 ;for 8-bit colour
dp_endif:

bx lr
