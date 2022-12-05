;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  index_array
;;  flashes the indexed value at a given location in an array.
;;
;;  input arguments:
;;  r0 - Peripheral Base Address
;;  r1 - size of array
;;  r2 - array address  (array assumed to be 32 bit integers
;;  r3 - index (must be less than size of array)
;;
;;  no return value (just flashes LED connected to GPIO 18)

index_array:

        push{r0,r1,r2,r3,r4,r5,r6}
        mov r4,r1  ; move array size to local register
        mov r6,4  ; number of bytes per value
        ; check if index < size
        cmp r3,r1
        bge skip_index$   ; if index exceeds size  skip to end of function (ie no flashes)

                ; check passed so proceed to index into array

                ; calculate index  (r3 = r3 * 4(r6) bytes)
                mul r3,r3,r6

                ; index into array and load value to r5
                ldr r5,[r2,r3]

                ; prepare to flash answer
                mov r1,r5        ; value to flash
                mov r2,$100000   ; delay time of ~1 second (ie 1 sec on , 1 sec off)
                push{lr}  ; store current lr before it is overwritten during function call
                bl FLASH   ; call the FLASH function (same as in assignment 2)
                pop{lr} ; restore old lr value

        skip_index$:  ; jump landing point if index exceeds size

        pop{r0,r1,r2,r3,r4,r5,r6}  ; restore all registers back to how they were
                                ; at the start of the functiopn call

        bx lr  ; jump back to instruction after original function call
