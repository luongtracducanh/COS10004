;FBinit16.asm
;memory addresses of mailbox
MAIL_BASE  = $B880    ; separate into $B800 and $0080
MAIL_WRITE = $20      ;offset for WRITE register
MAIL_TAGS  = $08      ;Channel number stored in the lowest 4 bits
;memory addresses of GPU tags (key-value pairs user to program the GPU)
Allocate_Buffer       = $00040001 ; 0 (request), returns FB address
Set_Physical_Display  = $00048003 ; 640,480
Set_Virtual_Buffer    = $00048004 ; 640,480
Set_Depth	      = $00048005 ; 8 (Response: Bits Per Pixel)
Set_Virtual_Offset    = $00048009 ; 0,0 (Response: X In Pixels, Y In Pixels)
Set_Palette	      = $0004800B ; 0,2 (first index, value)
;many more here:
;https://github.com/raspberrypi/firmware/wiki/Mailbox-property-interface

; Setup Frame Buffer
SCREEN_X       = 640
SCREEN_Y       = 480
BITS_PER_PIXEL = 16	;was 8

FB_Init:
  ;copy param
  mov r1,r0
  ;mov r0,FB_STRUCT ;  FB_STRUCT is determined at run-time. If it is an illegal value, orr it into the register 2 bytes at a time
  mov r0,FB_STRUCT and $FF
  orr r0,FB_STRUCT and $FF00
  orr r0,FB_STRUCT and $FF0000
  orr r0,FB_STRUCT and $FF000000
  orr r0,MAIL_TAGS  ;send key-value pairs to GPU

  ;imm32 r0,MAIL_WRITE + MAIL_TAGS
 ; mov r1,BASE
  orr r1,MAIL_BASE and $00FF
  orr r1,MAIL_BASE and $FF00
  orr r1,MAIL_WRITE
  orr r1,MAIL_TAGS
  str r0,[r1] ;Mail Box Write

  ldr r0,[FB_POINTER] ; send address of FB struct to mailbox
  ;mailbox delivers to GPU, sends back reply (0 fail) or pointer to screen
  cmp r0,0 ; Compare Frame Buffer Pointer To Zero
  beq FB_Init ; IF Zero try again
  bx lr        ;return r0 - pointer th screen


align 16
FB_STRUCT: ; Mailbox Property Interface Buffer Structure
  dw FB_STRUCT_END - FB_STRUCT ; Buffer Size In Bytes (Including The Header Values, The End Tag And Padding)
  dw $00000000 ; Buffer Request/Response Code
	       ; Request Codes: $00000000 Process Request Response Codes: $80000000 Request Successful, $80000001 Partial Response
; Sequence Of Concatenated Tags
  dw Set_Physical_Display ; Tag Identifier
  dw $00000008 ; Value Buffer Size In Bytes
  dw $00000008 ; 1 bit (MSB) Request/Response Indicator (0=Request, 1=Response), 31 bits (LSB) Value Length In Bytes
  dw SCREEN_X ; Value Buffer
  dw SCREEN_Y ; Value Buffer

  dw Set_Virtual_Buffer ; Tag Identifier
  dw $00000008 ; Value Buffer Size In Bytes
  dw $00000008 ; 1 bit (MSB) Request/Response Indicator (0=Request, 1=Response), 31 bits (LSB) Value Length In Bytes
  dw SCREEN_X ; Value Buffer
  dw SCREEN_Y ; Value Buffer

  dw Set_Depth ; Tag Identifier
  dw $00000004 ; Value Buffer Size In Bytes
  dw $00000004 ; 1 bit (MSB) Request/Response Indicator (0=Request, 1=Response), 31 bits (LSB) Value Length In Bytes
  dw BITS_PER_PIXEL ; Value Buffer

  dw Set_Virtual_Offset ; Tag Identifier
  dw $00000008 ; Value Buffer Size In Bytes
  dw $00000008 ; 1 bit (MSB) Request/Response Indicator (0=Request, 1=Response), 31 bits (LSB) Value Length In Bytes
FB_OFFSET_X:
  dw 0 ; Value Buffer
FB_OFFSET_Y:
  dw 0 ; Value Buffer

  dw Set_Palette ; Tag Identifier
  dw $00000010 ; Value Buffer Size In Bytes
  dw $00000010 ; 1 bit (MSB) Request/Response Indicator (0=Request, 1=Response), 31 bits (LSB) Value Length In Bytes
  dw 0 ; Value Buffer (Offset: First Palette Index To Set (0-255))
  dw 2 ; Value Buffer (Length: Number Of Palette Entries To Set (1-256))
FB_PAL:
  dw $00000000,$FFFFFFFF ; RGBA Palette Values (Offset To Offset+Length-1)

  dw Allocate_Buffer ; Tag Identifier
  dw $00000008 ; Value Buffer Size In Bytes
  dw $00000008 ; 1 bit (MSB) Request/Response Indicator (0=Request, 1=Response), 31 bits (LSB) Value Length In Bytes
FB_POINTER:  ;pointer to start of screen
  dw 0 ; Value Buffer
  dw 0 ; Value Buffer

dw $00000000 ; $0 (End Tag)
FB_STRUCT_END:

