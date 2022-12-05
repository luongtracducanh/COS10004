; function stage2_flash_array
; flashes the contents of array given
; Arguments:
; r0 - BASE address of peripherals
; r1 - size of array
; r2 - array to flash
; Function returns nothing

stage2_flash_array:
        ; implement your function here
        ; remember to push any registers you use to the stack before you use them
        ; ( and pop them off at the very end)
        push {r8}

        loop:
          ldr r8,[r2],#4 ; load array to flash
          
        push {lr,r1,r2}
        mov r1,r8

        ; your function should make use of the existing functions FLASH and PAUSE
        mov r2,$20000
        bl FLASH
        mov r1,$200000
        bl PAUSE
        pop {lr,r1,r2}
        sub r1,#1 ; decrement the size of the array
        cmp r1,#0 ; compare r1 to 0
        bgt loop ; loop if size > 0
        pop {r8}
        bx lr