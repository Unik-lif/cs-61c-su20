## Lab 8 answers:
### ex1:
1. page size is $2^{5}$, 32 Bytes.
2. It depends.
3. Yes. because it revisit a VA which has already be mapped with PA and not evicted yet.
4. When we want to visit a VA, first we check the TLB table, and the line where VA points to (VPN) is empty, it will result in TLB misses. Secondly, since TLB misses, the system will look into the RAM to find the page table, but the page table is still empty, it will bring page faults to the system. So the system should load message from the disk, updates not only the page table in the RAM, but also the TLB. Since the RAM is empty, the physical page will be loaded, and the TLB table should be updated.

### ex2:
```
00 20 40 60 80 a0 c0 e0 00 20
```

### ex3:
just make page table larger!

### ex4:
p is the processes. When processes switch, the TLB must be flushed. So the stored value in TLB cannot be used at once if the process only access a little part of memory.