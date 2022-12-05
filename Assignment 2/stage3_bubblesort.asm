; function stage3_bubblesort
; sorts numarray using the sorting algorithm bubble sort
; Arguments:
; r0 - size of array
; r1 - array to flash
; r2 - BASE address of peripherals

stage3_bubblesort:
        ; implement your function here
        ; remember to push any registers you use to the stack before you use them
        ; ( and pop them off at the very end)
        push {lr,r0-r11}
        mov r3,r0 ; r3 = size of array
        mov r6,r0
        sub r6,#1 ; r6 = size of array - 1
        mov r11,r6 ; r11 = index sĩze
        lsl r6,#2 ; shift left r6 by 2
        mov r10,#0 ; keep track of sort times
        mov r4,r1 ; r4 = array
        
        sort1:
          mov r5,#0 ; current index
          mov r7,#4 ; next index
            sort2:
              ldr r9,[r4,r5] ; load current index
              ldr r8,[r4,r7] ; load next index
              cmp r9,r8 ; compare 2 indexes
              blt next ; if current < next then branch to next
              str r8,[r4,r5] ; store current to next
              str r9,[r4,r7] ; store next to current

              next:
                add r5,#4 ; add 4 to current index
                add r7,#4 ; add 4 to next index
                cmp r7,r6 ; compare the next two index
                ble sort2 ; if current > next then branch to sort2
            add r10,#1 ; add 1 for each sort
            cmp r10,r11 ; compare the number of sorted times to index size
            ble sort1 ; if larger then branch to sort1

        push {lr,r0-r4}
        ; your function must mov the address of the sorted array to r0
        mov r0,r2 ; return BASE address
        mov r2,r4 ; return array to flash
        mov r1,r3 ; return size of array
        bl stage2_flash_array ; flash the sorted array
        pop {lr,r0-r4}
        pop {lr,r0-r11}
        bx lr