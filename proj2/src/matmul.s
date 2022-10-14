.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Notice that this function is caller, so we should avoid
# using temporary registers.
# =======================================================
matmul:

    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    sw ra, 48(sp)

    # store all the argument used in the function to some temp register.
    # ------------------------------------------------------------------
    mv s0, a0 # s0, start position of the m0 matrix.
    mv s1, a1 # the num of row of m0.
    mv s2, a2 # the num of column of m0.
    mv s3, a3 # s3, start postion of the m1 matrix.
    mv s4, a4 # the num of row of m1.
    mv s5, a5 # the num of column of m1.
    mv s6, a6 # the pointer of the start of d.
    # -----------------------------------------------------------------

    # Error checks
    # ----------------
    beq s1, x0, fail1
    beq s2, x0, fail1
    beq s4, x0, fail2
    beq s5, x0, fail2
    bne s2, s4, fail3
    # ----------------

    # Prologue

    # Normal case preparation.
    # -------------------------------------------
    mv s7, x0 # use s7 for the outer_loop
    mv s8, x0 # use s8 for the inner_loop
    # -------------------------------------------

outer_loop_start:

    # cursor through the row of the m0
    beq s7, s1, outer_loop_end

inner_loop_start:

    # cursor through the column of the m1.
    beq s8, s5, inner_loop_end
    
    # we want s9 finally can represents the start position of the m0 matrix.(int type considered)
    mul s9, s7, s2

    # find the start position of the row of m0.
    slli s9, s9, 2
    add s9, s0, s9 

    slli s10, s8, 2
    add s10, s3, s10 # find the start position of the column of m1.

    mv a0, s9 # s2, s3 use to compute parameter of the dot_product function.
    mv a1, s10
    
    mul a2, s4, s5
    addi a3, x0, 1 # stride for the m0, set to 1 because it is a row.
    add a4, x0, s5 # stride for the m1, set to s5 because it is a column.
    jal ra, dot

    addi s11, a0, 0 # store the result in s11, s11 is the temp register for dot result.


    # get the position to store the s11.
    mul s9, s7, s5
    
    add s9, s9, s8
    slli s9, s9, 2
    add s9, s9, s6

    # store s11 result.
    sw s11, 0(s9)

    addi s8, s8, 1
    
    jal inner_loop_start

inner_loop_end:

    addi s8, x0, 0
    addi s7, s7, 1
    j outer_loop_start


outer_loop_end:


    # Epilogue
    addi a0, s6, 0

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52

    ret

fail1:
    addi a1, x0, 2
    jal ra, exit2

fail2:
    addi a1, x0, 3
    jal ra, exit2

fail3:
    addi a1, x0, 4
    jal ra, exit2
