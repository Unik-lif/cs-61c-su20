.data
source:
    .word   3
    .word   1
    .word   4
    .word   1
    .word   5
    .word   9
    .word   0
dest:
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0

.text
main:
    addi t0, x0, 0
    addi s0, x0, 0
    la s1, source
    la s2, dest
loop:
    slli s3, t0, 2 ## multiple 4.
    add t1, s1, s3 ## get t1 the true position of the source[k].
    lw t2, 0(t1) ## load source[k] into t2.
    beq t2, x0, exit ## judge whether t2 is 0, if it is 0, then exit.
    add a0, x0, t2 ## add t2 with x0, get a0. a0 is equal to t2 now. a0 is used as argument of func().
    addi sp, sp, -8 
    sw t0, 0(sp)
    sw t2, 4(sp)
    jal square ## ar is stored the address of the line 38.
    lw t0, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8
    add t2, x0, a0
    add t3, s2, s3 ## sum is s0, apparently.
    sw t2, 0(t3)
    add s0, s0, t2
    addi t0, t0, 1
    jal x0, loop
square: ## two registers are used, so basically we have 8 bytes allocated beforehand.
    add t0, a0, x0 
    add t1, a0, x0
    addi t0, t0, 1
    addi t2, x0, -1 ## t2 is -1.
    mul t1, t1, t2 ## t1 is transferred to -t1.
    mul a0, t0, t1 ## multiple these two to get the result. stored in a0.
    jr ra
exit:
    add a0, x0, s0
    add a1, x0, x0
    ecall # Terminate ecall