.globl classify

.data
m0_row: .word 0
m0_col: .word 0
m1_row: .word 0
m1_col: .word 0
in_row: .word 0
in_col: .word 0

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
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

    mv s0, a0
    mv s1, a1
    mv s2, a2

    li s3, 5
    bne s0, s3, commandlinefail
    # after that, s0 is no longer used.

    # =====================================
    # LOAD MATRICES
    # =====================================

    # the load process got some problems and bugs to be fixed up.

    # Load pretrained m0
    # --------------- s3 for load address, s4 for the matrix. ----------------
    lw s3, 4(s1)
    mv a0, s3
    la a1, m0_row
    la a2, m0_col
    jal ra, read_matrix

    mv s4, a0
    # handy usage, to compute the matmul afterwards.
    la s7, m0_row
    lw s7, 0(s7)
    la s8, m0_col
    lw s8, 0(s8)

    # Load pretrained m1
    # --------------- s3 for load address, s5 for the matrix. ----------------
    lw s3, 8(s1)
    mv a0, s3
    la a1, m1_row
    la a2, m1_col
    jal ra, read_matrix

    mv s5, a0

    la s9, m1_row
    lw s9, 0(s9)
    la s10, m1_col
    lw s10, 0(s10)  

    
    # Load input matrix (read_matrix got some problem, fail to judge the 3 * 1 cases)
    # --------------- s3 for load address, s6 for the matrix. ----------------
    lw s3, 12(s1)
    mv a0, s3
    la a1, in_row
    la a2, in_col
    jal ra, read_matrix

    mv s6, a0

    la s11, in_row
    lw s11, 0(s11)
    la s0, in_col
    lw s0, 0(s0)    

    
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    
    # first: matmul
    # col of m0, row of input.
    mul a0, s7, s0 #
    slli a0, a0, 2
    jal ra, malloc
    blt a0, x0, mallocfail

    mv s3, a0
    
    mv a0, s4
    mv a1, s7
    mv a2, s8

    mv a3, s6
    mv a4, s11
    mv a5, s0
    mv a6, s3

    jal ra, matmul
    
    # Wait to be freed later.
    mv s3, a6

    # second: relu
    mv a0, a6
    mul a1, s7, s0
    jal ra, relu
    
    
    # third: matmul
    # col of m1.
    mv a3, a0

    mul a0, s9, s0
    slli a0, a0, 2
    jal ra, malloc

    mv a6, a0

    mv a0, s5
    mv a1, s9
    mv a2, s10    

    mv a4, s7
    mv a5, s0

    jal ra, matmul

    # wait to be freed.
    mv s4, a6

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a1, a6
    lw a0, 16(s1)
    mv a2, s9
    mv a3, s0

    jal ra, write_matrix




    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s4
    mul a1, s9, s0
    jal ra, argmax

    # Print classification
    mv a1, a0
    jal print_int


    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char

    # free the last matrix space.
    mv a0, s3
    jal ra, free
    mv a0, s4
    jal ra, free

no_print:

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

mallocfail:
    addi a1, x0, 48
    jal ra, exit2

commandlinefail:
    li a1, 49
    jal ra, exit2
