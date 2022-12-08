; function stage4_quicksort
; sorts given array using the sorting algorithm quicksort
; Arguments:
; r0 - size of array
; r1 - array to flash
; r2 - BASE address of peripherals

stage4_quicksort:
        ; implement your function here
        ; remember to push any registers you use to the stack before you use them
        ; ( and pop them off at the very end)
        adr r1, numarray2 ; array address

        quicksort:
          push {r0-r10,lr}
          mov r4,r1 ; r4 = address
          mov r5,r0 ; r5 = size
          cmp r5,#1 ; compare size to 1
          ble finish ; if size < 1 then finish
          cmp r5,#2 ; compare size to 2
          beq check_sorted ; if size != 2 then start to compare

        partition:
          mov r1,#1
          lsr r2,r5,r1 ; middle index
          ldr r6,[r4] ; load first index
          ldr r7,[r4,r2,lsl #2] ; load middle index
          sub r8,r5,#1 ; last index
          ldr r8,[r4,r8,lsl #2] ; load last index
          cmp r6,r7 ; compare first and middle
          movgt r9,r6 ; swap if first > middle, r9 acts as a temp
          movgt r6,r7
          movgt r7,r9
          cmp r7,r8 ; compare middle and last
          movgt r9,r7 ; swap if middle > last, r9 acts as a temp
          movgt r7,r8
          movgt r8,r9
          cmp r6,r7 ; compare first and middle
          movgt r9,r6
          movgt r6,r7
          mov r7,r9
          mov r6,r7 ; r6 is pivot
          mov r7,#0 ; index of 1st element
          sub r8,r5,#1 ; index of last element

        loop1:
          ldr r0,[r4,r7,lsl #2] ; load smaller value
          ldr r1,[r4,r8,lsl #2] ; load larger value
          cmp r0,r6 ; compare lower value and pivot
          beq loop2 ; branch to loop 2 if equal
          addlt r7,r7,#1 ; if smaller value < pivot then move to next pair
          strgt r0,[r4,r8,lsl #2]
          subgt r8,r8,#1 ; decrement larger index
          cmp r7,r8 ; compare 2 indexes
          beq recursion ; recursion when they are equal
          ldr r0,[r4,r7,lsl #2] ; load smaller value
          ldr r1,[r4,r8,lsl #2] ; load larger value

        loop2:
          cmp r1,r6 ; compare larger value to pivot
          subgt r8,r8,#1 ; decrement if larger
          strlt r0,[r4,r8,lsl #2] ; if smaller then swap
          strlt r1,[r4,r7,lsl #2]
          addlt r7,r7,#1 ; increment smaller value
          cmp r7,r8 ; compare 2 indexes
          beq recursion ; recursion when they are equal
          b loop1 ; branch to loop1

        recursion:
          mov r1,r4 ; index
          mov r0,r7 ; length
          bl quicksort ; sort
          add r8,r8,#1 ; increment last index by 1
          cmp r8,r5 ; compare last index to length
          bge finish ; exit the loop
          add r1,r4,r8,lsl #2 ; index of next
          sub r0,r5,r8 ; length of next
          bl quicksort ; sort next
          b finish ; exit the loop
        
        check_sorted:
          ldr r0,[r4] ; load current value
          ldr r1,[r4,#4] ; load next value
          cmp r0,r1; compare current and next
          ble finish ; if current < next then return
          str r1,[r4] ; else swap the 2 element
        ; your function must mov the address of the sorted array to r0
          str r0,[r4,#4] ; swap

        finish:
          pop {r0-r10,lr} ; return call
        
        bx lr