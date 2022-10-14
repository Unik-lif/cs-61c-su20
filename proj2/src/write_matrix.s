.globl write_matrix

.data
row: .word 0
col: .word 0

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# s0: filepath
# s1: the pointer to the start of the matrix in memory
# s4: file descriptor
# ==============================================================================
write_matrix:
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    # load row and col in the .data segment.
    la a2, row
    la a3, col

    sw s2, 0(a2)
    sw s3, 0(a3)

    # fopen the file.
    mv a1, s0
    li a2, 1
    jal ra, fopen
    blt a0, x0, fopenfail
    mv s4, a0

    # fwrite the row and the column
    mv a1, s4
    la a2, row
    li a3, 1
    li a4, 4
    jal ra, fwrite
    blt a0, a3, fwritefail

    mv a1, s4
    la a2, col
    li a3, 1
    li a4, 4
    jal ra, fwrite
    blt a0, a3, fwritefail
    
    mv a1, s4
    mv a2, s1
    mul a3, s2, s3
    li a4, 4
    jal ra, fwrite
    blt a0, a3, fwritefail

    # fclose
    mv a1, s4
    jal ra, fclose
    blt a0, x0, fclosefail


    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24
    
    ret

fopenfail:
    li a1, 53
    jal ra, exit2

fwritefail:
    mv a1, s4
    jal ra, fflush
    li a1, 54
    jal ra, exit2

fclosefail:
    li a1, 55
    jal ra, exit2