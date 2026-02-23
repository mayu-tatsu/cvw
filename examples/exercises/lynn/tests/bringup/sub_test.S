// C Runtime entry point
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_sub_test
.extern fail

    .section .text.init
    .globl sub_test
    .type  sub_test, @function

sub_test:
    // basic: 9 - 4 = 5
    test1:
        li   t0, 9
        li   t1, 4
        sub  t2, t0, t1
        li   t3, 5
        beq  t2, t3, test2
        j    Fail_Sub_1

    // basic: 27 - 14 = 13
    test2:
        li   t0, 27
        li   t1, 14
        sub  t2, t0, t1
        li   t3, 13
        beq  t2, t3, test3
        j    Fail_Sub_2

    // subtract zero: x - 0 = x
    test3:
        li   t0, 42
        li   t1, 0
        sub  t2, t0, t1
        li   t3, 42
        beq  t2, t3, test4
        j    Fail_Sub_3

    // subtract self: x - x = 0
    test4:
        li   t0, 99
        sub  t2, t0, t0
        li   t3, 0
        beq  t2, t3, test5
        j    Fail_Sub_4

    // subtract from zero: 0 - x = -x
    test5:
        li   t0, 0
        li   t1, 15
        sub  t2, t0, t1
        li   t3, -15
        beq  t2, t3, test6
        j    Fail_Sub_5

    // result is negative: 5 - 20 = -15
    test6:
        li   t0, 5
        li   t1, 20
        sub  t2, t0, t1
        li   t3, -15
        beq  t2, t3, test7
        j    Fail_Sub_6

    // neg - neg = pos: -10 - (-30) = 20
    test7:
        li   t0, -10
        li   t1, -30
        sub  t2, t0, t1
        li   t3, 20
        beq  t2, t3, test8
        j    Fail_Sub_7

    // neg - neg = neg: -30 - (-10) = -20
    test8:
        li   t0, -30
        li   t1, -10
        sub  t2, t0, t1
        li   t3, -20
        beq  t2, t3, test9
        j    Fail_Sub_8

    // neg - pos = neg: -15 - 8 = -23
    test9:
        li   t0, -15
        li   t1, 8
        sub  t2, t0, t1
        li   t3, -23
        beq  t2, t3, test10
        j    Fail_Sub_9

    // underflow wrap: 0x80 - 1 = 0x7F (min negative - 1 = max positive in 8-bit)
    test10:
        li   t0, 0x80
        li   t1, 1
        sub  t2, t0, t1
        li   t3, 0x7F
        beq  t2, t3, test11
        j    Fail_Sub_10

    // overflow wrap: 0x7F - (-1) = 0x80
    test11:
        li   t0, 0x7F
        li   t1, -1
        sub  t2, t0, t1
        li   t3, 0x80
        beq  t2, t3, test12
        j    Fail_Sub_11

    // subtract 1 (decrement): 100 - 1 = 99
    test12:
        li   t0, 100
        li   t1, 1
        sub  t2, t0, t1
        li   t3, 99
        beq  t2, t3, pass
        j    Fail_Sub_12

    pass:
        j return_sub_test

Fail_Sub_1:
    li   gp, 401
    j    fail

Fail_Sub_2:
    li   gp, 402
    j    fail

Fail_Sub_3:
    li   gp, 403
    j    fail

Fail_Sub_4:
    li   gp, 404
    j    fail

Fail_Sub_5:
    li   gp, 405
    j    fail

Fail_Sub_6:
    li   gp, 406
    j    fail

Fail_Sub_7:
    li   gp, 407
    j    fail

Fail_Sub_8:
    li   gp, 408
    j    fail

Fail_Sub_9:
    li   gp, 409
    j    fail

Fail_Sub_10:
    li   gp, 410
    j    fail

Fail_Sub_11:
    li   gp, 411
    j    fail

Fail_Sub_12:
    li   gp, 412
    j    fail
