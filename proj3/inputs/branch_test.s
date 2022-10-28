beq x0, x0, label1
addi x1, x0, 5
label1:
    addi x1, x0, 5
    bne x1, x0, label2
    addi t1, x0, 5
label2:
    addi t1, x0, 5
    blt  t1, x1, label3
    addi t2, x0, 6
label3:
    bge t1, x1, label4
    addi t2, x0, 5
label4:
    