; function stage1b_max
; returns the maximum value out of three arguments passed in
; Arguments:
; r0 - first value
; r1 - second value
; r2 - third value
; Returns result in r0 register

stage1b_max:
        ; implement your function here
        ; remember to push any registers you use to the stack before you use them
        ; ( and pop them off at the very end)
        push {r1,r2,r3}
        mov r3,r0 ; assign 1st index to r3
        cmp r3,r1 ; compare the 2 first index
        bgt exit3 ; if r3 > r1 then branch to exit3
        mov r3,r1 ; else move r1 to r3
        b exit3 ; branch to exit3

        exit3:
          cmp r3,r2 ; compare r3 to r2
          bgt exit4 ; if r3 > r2 then branch to exit3
          mov r3,r2 ; else move r2 to r3
          b exit4 ; branch to exit4

        ; this is a place holder - replace "1" with the register holding the return value
        exit4:
          mov r0,r3 ; return the max value to r0

        pop {r1,r2,r3}
        bx  lr