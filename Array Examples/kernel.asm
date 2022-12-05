;  Kernel.asm
; Array demonstration
; Sum an array and flash the answer

; initialise base address for your PI (choose only one of these and comment
; out the other (Pi 4 by default)

BASE=$FE000000 ; RPI 4 Peripherals address ;
;BASE=$3F000000 for RP2 and RP3 Peripherals address

mov sp,$1000  ;make room on the stack


; Array Initalisation
align 2
numarray:
      dw 1, 2, 3, 1, 2
mov r8,5  ; array size

INDEX=4

; Start-up flash sequence - 7 short flashes
mov r0,BASE
mov r1,7;
mov r2,$20000  ; pause time between flashes
bl FLASH
mov r1,$200000 ; pause time
bl PAUSE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Call a function to flash the value at an indexed position in an array

; Pass arguments to function

mov r0,BASE ; pass peripheral base address
mov r1,r8  ; size of arrays
adr r2,numarray
mov r3,INDEX  ; index of value to flash

bl index_array

;; insert a pause
mov r1, $200000
mov r0, BASE
bl PAUSE   ; Pause for 2 seconds


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Call a function to sum the values in an array and flash the answer

; Pass arguments to function
mov r0,BASE ; pass peripheral base address
mov r1,r8  ; size of arrays
adr r2,numarray
bl sum_array

; Completion flash sequence - 7 short flashes
mov r0,BASE
mov r1,7;
mov r2,$20000  ; pause time between flashes r10
bl FLASH
mov r1,$200000 ; pause time
bl PAUSE

finalloop$:
b finalloop$


include "FLASH.asm"
include "PAUSE.asm"
include "index_array.asm"
include "sum_array.asm"


