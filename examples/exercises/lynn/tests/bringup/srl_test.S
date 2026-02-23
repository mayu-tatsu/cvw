.extern return_srl_test
.extern fail

    .section .text.init
    .globl srl_test
    .type  srl_test, @function

srl_test:
    // test1: srl basic - 8 >> 1 = 4
    test1:
        li   t0, 8
        li   t1, 1
        srl  t2, t0, t1
        li   t3, 4
        beq  t2, t3, test2
        j    Fail_Srl_1

    // test2: srl - 16 >> 4 = 1
    test2:
        li   t0, 16
        li   t1, 4
        srl  t2, t0, t1
        li   t3, 1
        beq  t2, t3, test3
        j    Fail_Srl_2

    // test3: srl shift by 0 = no change
    test3:
        li   t0, 0xAB
        li   t1, 0
        srl  t2, t0, t1
        li   t3, 0xAB
        beq  t2, t3, test4
        j    Fail_Srl_3

    // test4: srl is logical - high bit filled with 0 (negative value >> 1 is positive)
    test4:
        li   t0, 0x80000000     // most negative 32-bit int
        li   t1, 1
        srl  t2, t0, t1
        li   t3, 0x40000000     // logical shift: 0 fills in MSB
        beq  t2, t3, test5
        j    Fail_Srl_4

    // test5: srl - shift all bits out = 0
    test5:
        li   t0, 0x1
        li   t1, 1
        srl  t2, t0, t1
        li   t3, 0
        beq  t2, t3, test6
        j    Fail_Srl_5

    // test6: srl only uses lower 5 bits of shift amount
    test6:
        li   t0, 32
        li   t1, 32         // lower 5 bits = 0, so shift by 0
        srl  t2, t0, t1
        li   t3, 32
        beq  t2, t3, test7
        j    Fail_Srl_6

    // test7: srl - 0xFFFFFFFF >> 4 = 0x0FFFFFFF (logical)
    test7:
        li   t0, 0xFFFFFFFF
        li   t1, 4
        srl  t2, t0, t1
        li   t3, 0x0FFFFFFF
        beq  t2, t3, test8
        j    Fail_Srl_7

    // test8: srli basic - 8 >> 2 = 2
    test8:
        li   t0, 8
        srli t2, t0, 2
        li   t3, 2
        beq  t2, t3, test9
        j    Fail_Srl_8

    // test9: srli shift by 0
    test9:
        li   t0, 0xCD
        srli t2, t0, 0
        li   t3, 0xCD
        beq  t2, t3, test10
        j    Fail_Srl_9

    // test10: srli logical - 0x80000000 >> 1 = 0x40000000
    test10:
        li   t0, 0x80000000
        srli t2, t0, 1
        li   t3, 0x40000000
        beq  t2, t3, test11
        j    Fail_Srl_10

    // test11: srli - divide by 8 (shift right 3)
    test11:
        li   t0, 64
        srli t2, t0, 3
        li   t3, 8
        beq  t2, t3, pass
        j    Fail_Srl_11

    pass:
        j return_srl_test

Fail_Srl_1:
    li   gp, 1601
    j    fail

Fail_Srl_2:
    li   gp, 1602
    j    fail

Fail_Srl_3:
    li   gp, 1603
    j    fail

Fail_Srl_4:
    li   gp, 1604
    j    fail

Fail_Srl_5:
    li   gp, 1605
    j    fail

Fail_Srl_6:
    li   gp, 1606
    j    fail

Fail_Srl_7:
    li   gp, 1607
    j    fail

Fail_Srl_8:
    li   gp, 1608
    j    fail

Fail_Srl_9:
    li   gp, 1609
    j    fail

Fail_Srl_10:
    li   gp, 1610
    j    fail

Fail_Srl_11:
    li   gp, 1611
    j    fail
