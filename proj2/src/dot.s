.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# this function is still a calle, so we can use temporary
# registers freely.
# =======================================================
dot:

    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)

    mv t0, a0 # address of v0
    mv t1, a1 # address of v1
    add t2, a2, x0 # length of the vectors
    add t3, a3, x0 # stride of v0
    add t4, a4, x0 # stride of v1

    # t5 used for bad case.
    addi t5, x0, 1

    # Bad case
    blt t2, t5, fail1
    blt t3, t5, fail2
    blt t4, t5, fail2

    # Normal case
    # no need to consider the overflow, use 'mul' here simply.
    add t5, x0, x0 # t5 used as the v0 cursor
    add t6, x0, x0 # t6 used as the v1 cursor

    add s3, x0, x0 # s3 will store the result for the dot product.

loop_start:

    bge t5, t2, loop_end
    bge t6, t2, loop_end

    add s0, t5, x0
    add s1, t6, x0
    slli s0, s0, 2
    slli s1, s1, 2

    add s0, s0, t0
    add s1, s1, t1
    lw s0, 0(s0)
    lw s1, 0(s1)

    mul s2, s0, s1
    add s3, s3, s2

    add t5, t5, t3
    add t6, t6, t4
    jal loop_start

loop_end:


    # Epilogue
    add a0, x0, s3

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20


    ret

fail1:
    addi a1, x0, 5
    jal exit2

fail2:
    addi a1, x0, 6
    jal exit2