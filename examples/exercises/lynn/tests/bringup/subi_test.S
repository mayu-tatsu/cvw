// subi instruction doesn't exist
// subtraction w/ immediate is done via addi w/ negative imm
// subi rd, rs, imm  =  addi rd, rs, -imm

.extern return_subi_test
.extern fail

    .section .text.init
    .globl subi_test
    .type  subi_test, @function

subi_test:
    // basic: 9 - 4 = 5
    test1:
        li    t0, 9
        addi  t2, t0, -4
        li    t3, 5
        beq   t2, t3, test2
        j     Fail_Subi_1

    // basic: 27 - 14 = 13
    test2:
        li    t0, 27
        addi  t2, t0, -14
        li    t3, 13
        beq   t2, t3, test3
        j     Fail_Subi_2

    // subtract zero: x - 0 = x
    test3:
        li    t0, 42
        addi  t2, t0, 0
        li    t3, 42
        beq   t2, t3, test4
        j     Fail_Subi_3

    // subtract to zero: 99 - 99 = 0
    test4:
        li    t0, 99
        addi  t2, t0, -99
        li    t3, 0
        beq   t2, t3, test5
        j     Fail_Subi_4

    // result is negative: 5 - 20 = -15
    test5:
        li    t0, 5
        addi  t2, t0, -20
        li    t3, -15
        beq   t2, t3, test6
        j     Fail_Subi_5

    // subtract from zero: 0 - 15 = -15
    test6:
        li    t0, 0
        addi  t2, t0, -15
        li    t3, -15
        beq   t2, t3, test7
        j     Fail_Subi_6

    // neg - pos = more neg: -10 - 8 = -18
    test7:
        li    t0, -10
        addi  t2, t0, -8
        li    t3, -18
        beq   t2, t3, test8
        j     Fail_Subi_7

    // neg - neg = pos: -10 - (-30) = 20  =>  addi t0, -10, +30
    test8:
        li    t0, -10
        addi  t2, t0, 30
        li    t3, 20
        beq   t2, t3, test9
        j     Fail_Subi_8

    // underflow wrap: 0x80 - 1 = 0x7F
    test9:
        li    t0, 0x80
        addi  t2, t0, -1
        li    t3, 0x7F
        beq   t2, t3, test10
        j     Fail_Subi_9

    // decrement: 100 - 1 = 99
    test10:
        li    t0, 100
        addi  t2, t0, -1
        li    t3, 99
        beq   t2, t3, test11
        j     Fail_Subi_10

    // accumulate (rd == rs1): subtract in place, 50 - 5 - 5 = 40
    test11:
        li    t0, 50
        addi  t0, t0, -5
        addi  t0, t0, -5
        li    t3, 40
        beq   t0, t3, pass
        j     Fail_Subi_11

    pass:
        j return_subi_test

Fail_Subi_1:
    li   gp, 801
    j    fail

Fail_Subi_2:
    li   gp, 802
    j    fail

Fail_Subi_3:
    li   gp, 803
    j    fail

Fail_Subi_4:
    li   gp, 804
    j    fail

Fail_Subi_5:
    li   gp, 805
    j    fail

Fail_Subi_6:
    li   gp, 806
    j    fail

Fail_Subi_7:
    li   gp, 807
    j    fail

Fail_Subi_8:
    li   gp, 808
    j    fail

Fail_Subi_9:
    li   gp, 809
    j    fail

Fail_Subi_10:
    li   gp, 810
    j    fail

Fail_Subi_11:
    li   gp, 811
    j    fail
