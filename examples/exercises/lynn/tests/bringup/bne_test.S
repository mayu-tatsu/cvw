.extern return_bne_test
.extern fail

    .section .text.init
    .globl bne_test
    .type  bne_test, @function

bne_test:
    // test1: bne branches when values are different (5 != 10)
    test1:
        li   t0, 5
        li   t1, 10
        bne  t0, t1, test1_taken
        j    Fail_Bne_1
    test1_taken:
        j    test2

    // test2: bne does NOT branch when values are equal
    test2:
        li   t0, 7
        li   t1, 7
        bne  t0, t1, Fail_Bne_2
        j    test3

    // test3: bne with zero and nonzero
    test3:
        li   t0, 0
        li   t1, 1
        bne  t0, t1, test3_taken
        j    Fail_Bne_3
    test3_taken:
        j    test4

    // test4: bne with two zeros - should NOT branch
    test4:
        li   t0, 0
        li   t1, 0
        bne  t0, t1, Fail_Bne_4
        j    test5

    // test5: bne with negative values that differ
    test5:
        li   t0, -1
        li   t1, -2
        bne  t0, t1, test5_taken
        j    Fail_Bne_5
    test5_taken:
        j    test6

    // test6: bne with same negative value - should NOT branch
    test6:
        li   t0, -5
        li   t1, -5
        bne  t0, t1, Fail_Bne_6
        j    test7

    // test7: bne positive vs negative (same bit pattern impossible; different values)
    test7:
        li   t0, 1
        li   t1, -1
        bne  t0, t1, test7_taken
        j    Fail_Bne_7
    test7_taken:
        j    test8

    // test8: bne with max positive and min negative
    test8:
        li   t0, 0x7FFFFFFF
        li   t1, 0x80000000
        bne  t0, t1, test8_taken
        j    Fail_Bne_8
    test8_taken:
        j    test9

    // test9: bne - branch not taken, next instruction executes (fall-through check)
    test9:
        li   t0, 42
        li   t1, 42
        bne  t0, t1, Fail_Bne_9
        li   t2, 1              // should execute
        li   t3, 1
        beq  t2, t3, test10
        j    Fail_Bne_9

    // test10: bne where one operand is x0
    test10:
        li   t0, 99
        bne  t0, zero, test10_taken
        j    Fail_Bne_10
    test10_taken:
        j    test11

    // test11: bne where both operands are x0 - should NOT branch
    test11:
        bne  zero, zero, Fail_Bne_11
        j    pass

    pass:
        j return_bne_test

Fail_Bne_1:
    li   gp, 2301
    j    fail

Fail_Bne_2:
    li   gp, 2302
    j    fail

Fail_Bne_3:
    li   gp, 2303
    j    fail

Fail_Bne_4:
    li   gp, 2304
    j    fail

Fail_Bne_5:
    li   gp, 2305
    j    fail

Fail_Bne_6:
    li   gp, 2306
    j    fail

Fail_Bne_7:
    li   gp, 2307
    j    fail

Fail_Bne_8:
    li   gp, 2308
    j    fail

Fail_Bne_9:
    li   gp, 2309
    j    fail

Fail_Bne_10:
    li   gp, 2310
    j    fail

Fail_Bne_11:
    li   gp, 2311
    j    fail
