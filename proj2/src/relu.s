.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# 
# Notice that it calls no functions, so we can freely denote this as a callee,
# which can use the temporary registers freely.
# ==============================================================================
relu:
    # Prologue
    mv t0, a0 # use t0 to store the pointer to the array.
    addi t1, a1, 0
    
    # temporary use t2 register to store 1 to compare.
    addi t2, x0, 1
    blt t1, t2, fail 
    # when branch out to exit2, this procedure won't go back. So 'ra' is redundant.

    # normal case is shown below.
    addi t2, x0, 0

loop_start:
    
    beq t2, t1, loop_end
    # a word has length of 4 bytes.
    slli t3, t2, 2

    # get the element address, stored in t3.
    add t3, t3, t0

    # get the element. compare it with 0. if the element is smaller than 0, then t5 will be set to 1.
    lw t4, 0(t3)
    slt t5, t4, x0

    beq t5, x0, loop_continue 
    sw x0, 0(t3)

loop_continue:
 
    addi t2, t2, 1
    j loop_start

loop_end:


    # Epilogue
    ret

fail:
    addi a1, x0, 8
    jal exit2