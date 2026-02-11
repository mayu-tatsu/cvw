# fir.S

# void fir(int x[], int c[], int y[], int n, int m) {
#    int i, j;
#    for (i = 0; i < n - m + 1; i++) {
#        y[i] = 0;
#        for (j = 0; j < m; j++) {
#            y[i] = add_q31(y[i], mul_q31(c[j], x[i-j + (m-1)]));
#        }
#    }
# }

.globl fir


fir:
    # stack frame allocations
    addi sp, sp, -80    # allocate 80 bytes on stack
    sd ra, 0(sp)        # save return address
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp)
    sd s4, 40(sp)
    sd s5, 48(sp)
    sd s6, 56(sp)
    sd s7, 64(sp)
    sd s8, 72(sp)

    # move input args to saved registers
    mv s0, a0           # s0 = x[]
    mv s1, a1           # s1 = c[]
    mv s2, a2           # s2 = y[]
    mv s3, a3           # s3 = n
    mv s4, a4           # s4 = m

    # working under the constraints of 7 temp registers
    mv s5, zero         # s5 = i
    mv s6, zero         # s6 = n-m+1
    mv s7, zero         # s7 = j
    mv s8, zero         # s8 = y[i]

    # s5 = i : outer for-loop
    li s5, 0            # s5 = i = 0

    # s6 = n-m+1 : outer for-loop limit
    sub s6, s3, s4      # s6 = n - m
    addi s6, s6, 1      # + 1

outer_loop:

    # check limit: i < (n - m + 1)
    bge s5, s6, end_outer_loop          # if j >= n-m+1, go to end_outer_loop

    # s8 = y[i]
    li s8, 0            # s8 = y[i] = 0

    # s7 = j : inner for-loop
    li s7, 0            # s7 = j = 0

inner_loop:

    # check limit: if j < m
    bge s7, s4, end_inner_loop          # if i >= m, go to end_inner_loop

    # set t1 = c[i]
    slli t0, s7, 2      # t0 = i * 4 (byte offset)
    add t0, s1, t0      # t0 = &c[i]
    lw t1, 0(t0)        # t1 = c[i]

    # set index t0 = j - i + (m - 1)
    sub t0, s5, s7      # t0 = j - i
    add t0, t0, s4      # + m
    addi t0, t0, -1     # - 1

    # set t2 = x[j - i + (m - 1)]
    slli t0, t0, 2      # t0 = index * 4 (byte offset)
    add t0, s0, t0      # t0 = &x[j - i + (m - 1)]
    lw t2, 0(t0)        # t2 = x[j - i + (m - 1)]

    # call mul on c[i], x[j - i + (m - 1)]
    mv a0, t1           # set param: a0 = c[i]
    mv a1, t2           # set param: a1 = x[j-i+(m-1)]
    call mul_q31

    # save output
    mv t3, a0           # t3 = mul result

    # call add
    mv a0, s8           # set param: a0 = y[j]
    mv a1, t3           # set param: a1 = mul result
    call add_q31        # a0 = y[j] + mul result

    # save output
    mv s8, a0           # s8 = add result (new y[i])

    addi s7, s7, 1      # j++
    j inner_loop        # back to inner-j loop

end_inner_loop:

    # Store y[j]
    slli t0, s5, 2      # t0 = j * 4 (byte offset)
    add t0, s2, t0      # t0 = &y[j]
    sw s8, 0(t0)        # store word y[j] = accumulator

    # Increment outer loop counter
    addi s5, s5, 1      # i++
    j outer_loop        # back to outer-i loop

end_outer_loop:

    ld s8, 72(sp)
    ld s7, 64(sp)
    ld s6, 56(sp)
    ld s5, 48(sp)
    ld s4, 40(sp)
    ld s3, 32(sp)
    ld s2, 24(sp)
    ld s1, 16(sp)
    ld s0, 8(sp)
    ld ra, 0(sp)
    addi sp, sp, 80         # reset

    ret
