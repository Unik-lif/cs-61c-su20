.import ../../src/matmul.s
.import ../../src/utils.s
.import ../../src/dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 9
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la t0, m0
    la t1, m1
    la t2, d 

    mv a0, t0
    addi a1, x0, 3
    addi a2, x0, 3
    mv a3, t1
    addi a4, x0, 3
    addi a5, x0, 3
    mv a6, t2

    # Call matrix multiply, m0 * m1
    jal ra, matmul



    # Print the output (use print_int_array in utils.s)
    addi a1, x0, 3
    addi a2, x0, 3
    jal print_int_array


    # Exit the program
    jal exit