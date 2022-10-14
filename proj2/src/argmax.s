.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# this function is callee, so freely use the temporary registers.
# =================================================================
argmax:

    # Prologue
    addi t1, x0, 1
    blt a1, t1, fail

    # Normal case:
    mv t0, a0
    addi t1, a1, 0

    # Cursor.
    addi t2, x0, 0

    # Start max with min value of 0.
    addi t3, x0, 0

    # Smallest Index
    addi t5, x0, 0

loop_start:

    beq t2, t1, loop_end

    # we use t4 as address and the element.
    slli t4, t2, 2

    # Fetch the element
    add t4, t4, t0
    lw t4, 0(t4)

    bge t3, t4, loop_continue

    # if not directly jump to the loop_continue, then t4 is larger than t3.
    add t3, x0, t4
    add t5, t2, x0

loop_continue:

    addi t2, t2, 1
    j loop_start

loop_end:
    

    # Epilogue
    add a0, t5, x0

    ret

fail:
    addi a1, x0, 7
    jal exit2