;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sum_array
;;  flashes (to GPIO18) the sum of all values in a given array.
;;
;;  input arguments:
;;  r0 - Peripheral Base Address
;;  r1 - size of array
;;  r2 - array address  (array assumed to be 32 bit integers
;;
;;  no return value (just flashes LED connected to GPIO 18)

sum_array:

        push{r0,r1,r2,r4,r5,r6,r7,r8}
        mov r4,r1  ; move array size to local register

        ; check if array is empty or not
        cmp r1,0
        beq skip_sum$  ; if empty then skip sum

                mov r5,0   ; initialise accumulator to zer (this will hold the sum)
                mov r6,0  ; initialise current index
                mov r7,4  ; number of bytes per value to jump to next

                sum_loop$:
                        mul r8,r6,r7  ;calculate byte offset  ( byteoffset =  curr_index * 4 bytes)
                        ldr r3,[r2,r8] ; get current indexed value
                        add r5,r3  ; add current indexed value to accumulator
                        add r6,#1  ; increment current index
                        cmp r6,r1  ; compare current index (r6) with size of array (r1)
                        blt sum_loop$   ; if current index <  size loop again

                ; prepare to flash answer
                mov r1,r5        ; value to flash
                mov r2,$100000   ; delay time of ~1 second (ie 1 sec on , 1 sec off)
                push{lr}  ; store current lr before it is overwritten during function call
                bl FLASH   ; call the FLASH function (same as in assignment 2)
                pop{lr} ; restore old lr value

        skip_sum$:  ; jump landing point if array was empty

        pop{r0,r1,r2,r4,r5,r6,r7,r8}  ; restore all registers back to how they were
                                ; at the start of the functiopn call

        bx lr  ; jump back to instruction after original function call
