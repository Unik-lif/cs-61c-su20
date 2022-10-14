.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)

    # Prologue
	mv s0, a0
    mv s1, a1
    mv s2, a2

    # fopen the file.
    # ------------------------------------------
    mv a1, s0
    mv a2, x0
    jal ra, fopen
    
    blt a0, x0, fopenfail
    mv s3, a0
    # -----------------------------------------

        
    # fread the first 8 bytes of the file.
    # -----------------------------------------
    mv a1, s3
    mv a2, s1
    addi a3, x0, 4

    jal ra, fread

    bne a0, a3, freadfail

    mv a2, s2

    jal ra, fread

    bne a0, a3, freadfail
    # ----------------------------------------

    # ----------------------------------------------------
    lw s5, 0(s1)
    lw s6, 0(s2)
    mul a0, s5, s6 # compute the size of the matrix.

    slli a0, a0, 2
    jal malloc
    blt a0, x0, mallocfail
    addi s4, a0, 0
    # ---------------------------------------------------

    # fread the final part of the matrix.
    # ---------------------------------------------------
    mv a1, s3
    mv a2, s4
    mul a3, s5, s6
    slli a3, a3, 2

    jal fread
    bne a0, a3, freadfail
    # --------------------------------------------------

    # close the file.
    # --------------------------------
    mv a1, s3
    jal fclose

    blt a0, x0, fclosefail
    # -------------------------------

    mv a0, s4

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    ret

mallocfail:
    addi a1, x0, 48
    jal ra, exit2

fopenfail:
    addi a1, x0, 50
    jal ra, exit2

freadfail:
    addi a1, x0, 51
    jal ra, exit2

fclosefail:
    addi a1, x0, 52
    jal ra, exit2