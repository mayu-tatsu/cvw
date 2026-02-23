.extern return_sll_test
.extern fail

    .section .text.init
    .globl sll_test
    .type  sll_test, @function

sll_test:
    // test1: sll basic - 1 << 1 = 2
    test1:
        li   t0, 1
        li   t1, 1
        sll  t2, t0, t1
        li   t3, 2
        beq  t2, t3, test2
        j    Fail_Sll_1

    // test2: sll - 1 << 4 = 16
    test2:
        li   t0, 1
        li   t1, 4
        sll  t2, t0, t1
        li   t3, 16
        beq  t2, t3, test3
        j    Fail_Sll_2

    // test3: sll shift by 0 = no change
    test3:
        li   t0, 0x55
        li   t1, 0
        sll  t2, t0, t1
        li   t3, 0x55
        beq  t2, t3, test4
        j    Fail_Sll_3

    // test4: sll - shift out high bits (32-bit overflow)
    test4:
        li   t0, 0x1
        li   t1, 31
        sll  t2, t0, t1
        li   t3, 0x80000000
        beq  t2, t3, test5
        j    Fail_Sll_4

    // test5: sll - shift by 31 produces sign bit set
    test5:
        li   t0, 3
        li   t1, 4
        sll  t2, t0, t1
        li   t3, 48
        beq  t2, t3, test6
        j    Fail_Sll_5

    // test6: sll only uses lower 5 bits of shift amount
    test6:
        li   t0, 1
        li   t1, 32         // lower 5 bits = 0, so shift by 0
        sll  t2, t0, t1
        li   t3, 1
        beq  t2, t3, test7
        j    Fail_Sll_6

    // test7: slli basic - 1 << 3 = 8
    test7:
        li   t0, 1
        slli t2, t0, 3
        li   t3, 8
        beq  t2, t3, test8
        j    Fail_Sll_7

    // test8: slli shift by 0
    test8:
        li   t0, 0xAB
        slli t2, t0, 0
        li   t3, 0xAB
        beq  t2, t3, test9
        j    Fail_Sll_8

    // test9: slli - multiply by 4 (shift left 2)
    test9:
        li   t0, 10
        slli t2, t0, 2
        li   t3, 40
        beq  t2, t3, test10
        j    Fail_Sll_9

    // test10: slli shift by 31
    test10:
        li   t0, 1
        slli t2, t0, 31
        li   t3, 0x80000000
        beq  t2, t3, test11
        j    Fail_Sll_10

    // test11: sll result of 0 shifted left = 0
    test11:
        li   t0, 0
        li   t1, 15
        sll  t2, t0, t1
        li   t3, 0
        beq  t2, t3, pass
        j    Fail_Sll_11

    pass:
        j return_sll_test

Fail_Sll_1:
    li   gp, 1501
    j    fail

Fail_Sll_2:
    li   gp, 1502
    j    fail

Fail_Sll_3:
    li   gp, 1503
    j    fail

Fail_Sll_4:
    li   gp, 1504
    j    fail

Fail_Sll_5:
    li   gp, 1505
    j    fail

Fail_Sll_6:
    li   gp, 1506
    j    fail

Fail_Sll_7:
    li   gp, 1507
    j    fail

Fail_Sll_8:
    li   gp, 1508
    j    fail

Fail_Sll_9:
    li   gp, 1509
    j    fail

Fail_Sll_10:
    li   gp, 1510
    j    fail

Fail_Sll_11:
    li   gp, 1511
    j    fail
