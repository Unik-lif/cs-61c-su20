 li t0, 0x10000000
 li t1, 0x0fffffff
 bltu t1, t0, label1
 li t0, 5
label1:
    blt t0, t1, label2
    li t0, 6
label2:
    bgeu t1, t0, label3
    li t0, 10
label3:
    