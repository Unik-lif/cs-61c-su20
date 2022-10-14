.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_read_matrix_3x1.bin"
row: .word 0
column: .word 0
.text
main:
    # Read matrix into memory
    la a0, file_path
    la a1, row
    la a2, column
    
    jal ra, read_matrix

    # Print out elements of matrix
    # mv t0, a0
    la t1, row
    la t2, column
    lw a1, 0(t1)
    lw a2, 0(t2)
    jal ra, print_int_array

    # Terminate the program
    jal ra, exit