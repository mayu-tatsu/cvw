.extern return_bge_test
.extern fail

    .section .text.init
    .globl bge_test
    .type  bge_test, @function

bge_test:
    // test1: bge - branch taken when greater (5 >= 3)
    test1:
        li   t0, 5
        li   t1, 3
        bge  t0, t1, test1_taken
        j    Fail_Bge_1
    test1_taken:
        j    test2

    // test2: bge - branch taken when equal (7 >= 7)
    test2:
        li   t0, 7
        li   t1, 7
        bge  t0, t1, test2_taken
        j    Fail_Bge_2
    test2_taken:
        j    test3

    // test3: bge - NOT taken when less (2 < 5)
    test3:
        li   t0, 2
        li   t1, 5
        bge  t0, t1, Fail_Bge_3
        j    test4

    // test4: bge - positive >= negative (signed), branch taken (1 >= -1)
    test4:
        li   t0, 1
        li   t1, -1
        bge  t0, t1, test4_taken
        j    Fail_Bge_4
    test4_taken:
        j    test5

    // test5: bge - negative NOT >= positive (signed), not taken (-1 < 1)
    test5:
        li   t0, -1
        li   t1, 1
        bge  t0, t1, Fail_Bge_5
        j    test6

    // test6: bge - most positive >= most negative
    test6:
        li   t0, 0x7FFFFFFF
        li   t1, 0x80000000
        bge  t0, t1, test6_taken
        j    Fail_Bge_6
    test6_taken:
        j    test7

    // test7: bgeu - unsigned >= taken (5 >= 3)
    test7:
        li   t0, 5
        li   t1, 3
        bgeu t0, t1, test7_taken
        j    Fail_Bge_7
    test7_taken:
        j    test8

    // test8: bgeu - taken when equal
    test8:
        li   t0, 10
        li   t1, 10
        bgeu t0, t1, test8_taken
        j    Fail_Bge_8
    test8_taken:
        j    test9

    // test9: bgeu - 0xFFFFFFFF >= 1 unsigned, taken
    test9:
        li   t0, 0xFFFFFFFF
        li   t1, 1
        bgeu t0, t1, test9_taken
        j    Fail_Bge_9
    test9_taken:
        j    test10

    // test10: bgeu - 1 NOT >= 0xFFFFFFFF unsigned, not taken
    test10:
        li   t0, 1
        li   t1, 0xFFFFFFFF
        bgeu t0, t1, Fail_Bge_10
        j    test11

    // test11: bgeu - 0 >= 0 = true (equal), taken
    test11:
        li   t0, 0
        li   t1, 0
        bgeu t0, t1, pass
        j    Fail_Bge_11

    pass:
        j return_bge_test

Fail_Bge_1:
    li   gp, 2501
    j    fail

Fail_Bge_2:
    li   gp, 2502
    j    fail

Fail_Bge_3:
    li   gp, 2503
    j    fail

Fail_Bge_4:
    li   gp, 2504
    j    fail

Fail_Bge_5:
    li   gp, 2505
    j    fail

Fail_Bge_6:
    li   gp, 2506
    j    fail

Fail_Bge_7:
    li   gp, 2507
    j    fail

Fail_Bge_8:
    li   gp, 2508
    j    fail

Fail_Bge_9:
    li   gp, 2509
    j    fail

Fail_Bge_10:
    li   gp, 2510
    j    fail

Fail_Bge_11:
    li   gp, 2511
    j    fail
