.extern return_blt_test
.extern fail

    .section .text.init
    .globl blt_test
    .type  blt_test, @function

blt_test:
    // test1: blt - signed less than, branch taken (1 < 2)
    test1:
        li   t0, 1
        li   t1, 2
        blt  t0, t1, test1_taken
        j    Fail_Blt_1
    test1_taken:
        j    test2

    // test2: blt - not taken when equal (5 == 5)
    test2:
        li   t0, 5
        li   t1, 5
        blt  t0, t1, Fail_Blt_2
        j    test3

    // test3: blt - not taken when greater (10 > 3)
    test3:
        li   t0, 10
        li   t1, 3
        blt  t0, t1, Fail_Blt_3
        j    test4

    // test4: blt - negative < positive (signed) branch taken
    test4:
        li   t0, -1
        li   t1, 0
        blt  t0, t1, test4_taken
        j    Fail_Blt_4
    test4_taken:
        j    test5

    // test5: blt - positive NOT less than negative (signed) - 1 > -1
    test5:
        li   t0, 1
        li   t1, -1
        blt  t0, t1, Fail_Blt_5
        j    test6

    // test6: blt - most negative < most positive
    test6:
        li   t0, 0x80000000     // -2147483648 signed
        li   t1, 0x7FFFFFFF     // 2147483647 signed
        blt  t0, t1, test6_taken
        j    Fail_Blt_6
    test6_taken:
        j    test7

    // test7: bltu - unsigned less than, branch taken (1 < 2)
    test7:
        li   t0, 1
        li   t1, 2
        bltu t0, t1, test7_taken
        j    Fail_Blt_7
    test7_taken:
        j    test8

    // test8: bltu - not taken when equal
    test8:
        li   t0, 5
        li   t1, 5
        bltu t0, t1, Fail_Blt_8
        j    test9

    // test9: bltu - 0xFFFFFFFF is largest unsigned; 1 < 0xFFFFFFFF = true
    test9:
        li   t0, 1
        li   t1, 0xFFFFFFFF
        bltu t0, t1, test9_taken
        j    Fail_Blt_9
    test9_taken:
        j    test10

    // test10: bltu - 0xFFFFFFFF NOT less than 1 unsigned
    test10:
        li   t0, 0xFFFFFFFF
        li   t1, 1
        bltu t0, t1, Fail_Blt_10
        j    test11

    // test11: bltu - 0 < any nonzero unsigned = true
    test11:
        li   t0, 0
        li   t1, 0x80000000     // large unsigned value
        bltu t0, t1, pass
        j    Fail_Blt_11

    pass:
        j return_blt_test

Fail_Blt_1:
    li   gp, 2401
    j    fail

Fail_Blt_2:
    li   gp, 2402
    j    fail

Fail_Blt_3:
    li   gp, 2403
    j    fail

Fail_Blt_4:
    li   gp, 2404
    j    fail

Fail_Blt_5:
    li   gp, 2405
    j    fail

Fail_Blt_6:
    li   gp, 2406
    j    fail

Fail_Blt_7:
    li   gp, 2407
    j    fail

Fail_Blt_8:
    li   gp, 2408
    j    fail

Fail_Blt_9:
    li   gp, 2409
    j    fail

Fail_Blt_10:
    li   gp, 2410
    j    fail

Fail_Blt_11:
    li   gp, 2411
    j    fail
