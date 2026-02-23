.extern return_addi_test
.extern fail

    .section .text.init
    .globl addi_test
    .type  addi_test, @function

addi_test:
    test1:
        li    t0, 7
        addi  t2, t0, 5
        li    t3, 12
        beq   t2, t3, test2
        j     Fail_Addi_1

    test2:
        li    t0, 19
        addi  t2, t0, 23
        li    t3, 42
        beq   t2, t3, test3
        j     Fail_Addi_2

    // Positive overflow (within 12-bit range)
    test3:
        li    t0, 0x7F
        addi  t2, t0, 1
        li    t3, 0x80
        beq   t2, t3, test4
        j     Fail_Addi_3

    // neg overflow (min_neg - 1 = max_pos), using 8-bit-style values
    test4:
        li    t0, 0x80
        addi  t2, t0, -1        // 0x80 + (-1) = 0x7F
        li    t3, 0x7F
        beq   t2, t3, test5
        j     Fail_Addi_4

    // adding with 0: 2+0=2
    test5:
        li    t0, 2
        addi  t2, t0, 0
        beq   t2, t0, test6
        j     Fail_Addi_5

    // neg+pos=pos: -10 + 25 = 15
    test6:
        li    t0, -10
        addi  t2, t0, 25
        li    t3, 15
        beq   t2, t3, test7
        j     Fail_Addi_6

    // neg+pos=neg: -30 + 10 = -20
    test7:
        li    t0, -30
        addi  t2, t0, 10
        li    t3, -20
        beq   t2, t3, test8
        j     Fail_Addi_7

    // neg+neg: -15 + (-8) = -23
    test8:
        li    t0, -15
        addi  t2, t0, -8
        li    t3, -23
        beq   t2, t3, test9
        j     Fail_Addi_8

    // increment: 99 + 1 = 100
    test9:
        li    t0, 99
        addi  t2, t0, 1
        li    t3, 100
        beq   t2, t3, test10
        j     Fail_Addi_9

    // decrement: 100 + (-1) = 99
    test10:
        li    t0, 100
        addi  t2, t0, -1
        li    t3, 99
        beq   t2, t3, test11
        j     Fail_Addi_10

    // addi with itself as destination (accumulate): start at 0, add 246
    test11:
        li    t0, 0
        addi  t0, t0, 123
        addi  t0, t0, 123
        li    t3, 246
        beq   t0, t3, pass
        j     Fail_Addi_11

    pass:
        j return_addi_test

Fail_Addi_1:
    li   gp, 501
    j    fail

Fail_Addi_2:
    li   gp, 502
    j    fail

Fail_Addi_3:
    li   gp, 503
    j    fail

Fail_Addi_4:
    li   gp, 504
    j    fail

Fail_Addi_5:
    li   gp, 505
    j    fail

Fail_Addi_6:
    li   gp, 506
    j    fail

Fail_Addi_7:
    li   gp, 507
    j    fail

Fail_Addi_8:
    li   gp, 508
    j    fail

Fail_Addi_9:
    li   gp, 509
    j    fail

Fail_Addi_10:
    li   gp, 510
    j    fail

Fail_Addi_11:
    li   gp, 511
    j    fail
