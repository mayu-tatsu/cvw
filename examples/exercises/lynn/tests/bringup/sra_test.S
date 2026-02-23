.extern return_sra_test
.extern fail

    .section .text.init
    .globl sra_test
    .type  sra_test, @function

sra_test:
    // test1: sra basic positive - 8 >> 1 = 4 (same as srl for positive)
    test1:
        li   t0, 8
        li   t1, 1
        sra  t2, t0, t1
        li   t3, 4
        beq  t2, t3, test2
        j    Fail_Sra_1

    // test2: sra arithmetic - negative value keeps sign bit (-8 >> 1 = -4)
    test2:
        li   t0, -8
        li   t1, 1
        sra  t2, t0, t1
        li   t3, -4
        beq  t2, t3, test3
        j    Fail_Sra_2

    // test3: sra shift by 0 = no change
    test3:
        li   t0, -20
        li   t1, 0
        sra  t2, t0, t1
        li   t3, -20
        beq  t2, t3, test4
        j    Fail_Sra_3

    // test4: sra - 0x80000000 >> 1 = 0xC0000000 (sign extended)
    test4:
        li   t0, 0x80000000
        li   t1, 1
        sra  t2, t0, t1
        li   t3, 0xC0000000
        beq  t2, t3, test5
        j    Fail_Sra_4

    // test5: sra - shift negative all the way fills with 1s (-1 >> any = -1)
    test5:
        li   t0, -1             // 0xFFFFFFFF
        li   t1, 31
        sra  t2, t0, t1
        li   t3, -1             // all 1s
        beq  t2, t3, test6
        j    Fail_Sra_5

    // test6: sra only uses lower 5 bits of shift amount
    test6:
        li   t0, 64
        li   t1, 32             // lower 5 bits = 0, shift by 0
        sra  t2, t0, t1
        li   t3, 64
        beq  t2, t3, test7
        j    Fail_Sra_6

    // test7: sra positive large shift - 0x7FFFFFFF >> 31 = 0
    test7:
        li   t0, 0x7FFFFFFF
        li   t1, 31
        sra  t2, t0, t1
        li   t3, 0
        beq  t2, t3, test8
        j    Fail_Sra_7

    // test8: srai basic - -16 >> 2 = -4
    test8:
        li   t0, -16
        srai t2, t0, 2
        li   t3, -4
        beq  t2, t3, test9
        j    Fail_Sra_8

    // test9: srai shift by 0
    test9:
        li   t0, -99
        srai t2, t0, 0
        li   t3, -99
        beq  t2, t3, test10
        j    Fail_Sra_9

    // test10: srai positive - 100 >> 2 = 25
    test10:
        li   t0, 100
        srai t2, t0, 2
        li   t3, 25
        beq  t2, t3, test11
        j    Fail_Sra_10

    // test11: srai - arithmetic shift preserves sign through multiple shifts (-32 >> 3 = -4)
    test11:
        li   t0, -32
        srai t2, t0, 3
        li   t3, -4
        beq  t2, t3, pass
        j    Fail_Sra_11

    pass:
        j return_sra_test

Fail_Sra_1:
    li   gp, 1701
    j    fail

Fail_Sra_2:
    li   gp, 1702
    j    fail

Fail_Sra_3:
    li   gp, 1703
    j    fail

Fail_Sra_4:
    li   gp, 1704
    j    fail

Fail_Sra_5:
    li   gp, 1705
    j    fail

Fail_Sra_6:
    li   gp, 1706
    j    fail

Fail_Sra_7:
    li   gp, 1707
    j    fail

Fail_Sra_8:
    li   gp, 1708
    j    fail

Fail_Sra_9:
    li   gp, 1709
    j    fail

Fail_Sra_10:
    li   gp, 1710
    j    fail

Fail_Sra_11:
    li   gp, 1711
    j    fail
