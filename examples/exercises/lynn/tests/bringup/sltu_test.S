.extern return_sltu_test
.extern fail

    .section .text.init
    .globl sltu_test
    .type  sltu_test, @function

sltu_test:
    // test1: sltu - 1 < 2 unsigned = 1
    test1:
        li   t0, 1
        li   t1, 2
        sltu t2, t0, t1
        li   t3, 1
        beq  t2, t3, test2
        j    Fail_Sltu_1

    // test2: sltu - 2 < 1 unsigned = 0
    test2:
        li   t0, 2
        li   t1, 1
        sltu t2, t0, t1
        li   t3, 0
        beq  t2, t3, test3
        j    Fail_Sltu_2

    // test3: sltu - equal values = 0
    test3:
        li   t0, 5
        li   t1, 5
        sltu t2, t0, t1
        li   t3, 0
        beq  t2, t3, test4
        j    Fail_Sltu_3

    // test4: sltu - 0xFFFFFFFF (-1 signed) > 1 unsigned (not less than)
    test4:
        li   t0, 0xFFFFFFFF     // unsigned max, signed -1
        li   t1, 1
        sltu t2, t0, t1         // 0xFFFFFFFF < 1 unsigned? No -> 0
        li   t3, 0
        beq  t2, t3, test5
        j    Fail_Sltu_4

    // test5: sltu - 1 < 0xFFFFFFFF unsigned = 1
    test5:
        li   t0, 1
        li   t1, 0xFFFFFFFF
        sltu t2, t0, t1         // 1 < 0xFFFFFFFF unsigned? Yes -> 1
        li   t3, 1
        beq  t2, t3, test6
        j    Fail_Sltu_5

    // test6: sltu - 0 < anything nonzero = 1
    test6:
        li   t0, 0
        li   t1, 0x80000000     // large unsigned value
        sltu t2, t0, t1
        li   t3, 1
        beq  t2, t3, test7
        j    Fail_Sltu_6

    // test7: sltu - 0 < 0 = 0
    test7:
        li   t0, 0
        li   t1, 0
        sltu t2, t0, t1
        li   t3, 0
        beq  t2, t3, test8
        j    Fail_Sltu_7

    // test8: sltiu - 3 < 10 = 1
    test8:
        li   t0, 3
        sltiu t2, t0, 10
        li   t3, 1
        beq  t2, t3, test9
        j    Fail_Sltu_8

    // test9: sltiu - immediate is sign-extended then treated as unsigned
    //        sltiu t2, t0, -1  -> imm = 0xFFFFFFFF unsigned (max), any value < max = 1
    test9:
        li   t0, 100
        sltiu t2, t0, -1        // -1 sign-extended = 0xFFFFFFFF; 100 < 0xFFFFFFFF unsigned = 1
        li   t3, 1
        beq  t2, t3, test10
        j    Fail_Sltu_9

    // test10: sltiu - value equal to immediate = 0
    test10:
        li   t0, 7
        sltiu t2, t0, 7
        li   t3, 0
        beq  t2, t3, test11
        j    Fail_Sltu_10

    // test11: sltiu - 0 < 1 = 1 (nonzero test trick)
    test11:
        li   t0, 0
        sltiu t2, t0, 1         // 0 < 1 unsigned = 1; classic "is zero" test
        li   t3, 1
        beq  t2, t3, pass
        j    Fail_Sltu_11

    pass:
        j return_sltu_test

Fail_Sltu_1:
    li   gp, 1801
    j    fail

Fail_Sltu_2:
    li   gp, 1802
    j    fail

Fail_Sltu_3:
    li   gp, 1803
    j    fail

Fail_Sltu_4:
    li   gp, 1804
    j    fail

Fail_Sltu_5:
    li   gp, 1805
    j    fail

Fail_Sltu_6:
    li   gp, 1806
    j    fail

Fail_Sltu_7:
    li   gp, 1807
    j    fail

Fail_Sltu_8:
    li   gp, 1808
    j    fail

Fail_Sltu_9:
    li   gp, 1809
    j    fail

Fail_Sltu_10:
    li   gp, 1810
    j    fail

Fail_Sltu_11:
    li   gp, 1811
    j    fail
