; function stage1c_diff
; returns the difference between the max and min value out of three arguments passed in
; Arguments:
; r0 - first value
; r1 - second value
; r2 - third value
; Returns result in r0 register

stage1c_diff:
        ; implement your function here
        ; remember to push any registers you use to the stack before you use them
        ; ( and pop them off at the very end)
        push {r3,r4}
        push {lr,r0-r2}
        bl stage1a_min ; call the find min function
        mov r3,r0 ; assign r3 = min
        pop {lr,r0-r2}
        
        push {lr,r0-r2}
        bl stage1b_max ; call the find max function
        mov r4,r0 ; assign r4 = max
        pop {lr,r0-r2}

        ; this is a place holder - replace "1" with the register holding the return value
        sub r0,r4,r3 ; r0 = r3 - r4 = max - min
        pop {r3,r4}
        bx  lr