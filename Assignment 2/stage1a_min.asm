; function stage1a_min
; returns the minimum value out of three arguments passed in
; Arguments:
; r0 - first value
; r1 - second value
; r2 - third value
; Returns result in r0 register

stage1a_min:
        ; implement your function here
        ; remember to push any registers you use to the stack before you use them
        ; ( and pop them off at the very end)
        push {r1,r2,r3}
        mov r3,r0 ; assign 1st index to r3
        cmp r3,r1 ; compare the 2 first index
        blt exit1 ; if r3 < r1 then branch to exit1
        mov r3,r1 ; else move r1 to r3
        b exit1 ; branch to exit1

        exit1:
          cmp r3,r2 ; compare r3 to r2
          blt exit2 ; if r3 < r2 then branch to exit2
          mov r3,r2 ; else move r2 to r3
          b exit2 ; branch to exit2

        ; this is a place holder - replace "1" with the register holding the return value
        exit2:
          mov r0,r3 ; return the min value to r0

        pop {r1,r2,r3}
        bx  lr