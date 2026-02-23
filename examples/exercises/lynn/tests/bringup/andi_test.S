.extern return_andi_test
.extern fail

    .section .text.init
    .globl andi_test
    .type  andi_test, @function

andi_test:
    // alternating bits: 0x55 & 0xAA = 0x00
    test1:
        li    t0, 0x55
        andi  t2, t0, 0xAA
        li    t3, 0x00
        beq   t2, t3, test2
        j     Fail_Andi_1

    // complementary bytes: 0x3C & 0xC3 = 0x00
    test2:
        li    t0, 0x3C      // 00111100
        andi  t2, t0, 0xC3  // 11000011 -> 00000000
        li    t3, 0x00
        beq   t2, t3, test3
        j     Fail_Andi_2

    // AND with all 1s is identity: 0x39 & 0xFF = 0x39
    test3:
        li    t0, 0x39
        andi  t2, t0, 0xFF
        li    t3, 0x39
        beq   t2, t3, test4
        j     Fail_Andi_3

    // AND with 0 clears all: 0xB9 & 0x00 = 0x00
    test4:
        li    t0, 0xB9
        andi  t2, t0, 0
        li    t3, 0x00
        beq   t2, t3, test5
        j     Fail_Andi_4

    // idempotent: 0x6C & 0x6C = 0x6C
    test5:
        li    t0, 0x6C
        andi  t2, t0, 0x6C
        li    t3, 0x6C
        beq   t2, t3, test6
        j     Fail_Andi_5

    // mask lower nibble: 0x52 & 0x0F = 0x02
    test6:
        li    t0, 0x52
        andi  t2, t0, 0x0F
        li    t3, 0x02
        beq   t2, t3, test7
        j     Fail_Andi_6

    // mask upper nibble: 0x12 & 0xF0 = 0x10
    test7:
        li    t0, 0x12
        andi  t2, t0, 0xF0
        li    t3, 0x10
        beq   t2, t3, test8
        j     Fail_Andi_7

    // clear a specific bit: 0xFF & 0xDF = 0xDF (clears bit 5)
    test8:
        li    t0, 0xFF
        andi  t2, t0, 0xDF
        li    t3, 0xDF
        beq   t2, t3, test9
        j     Fail_Andi_8

    // sign bit preservation: 0x80 & 0x81 = 0x80
    test9:
        li    t0, 0x80
        andi  t2, t0, 0x81
        li    t3, 0x80
        beq   t2, t3, test10
        j     Fail_Andi_9

    // power of 2 check: 0x80 & 0x7F = 0x00
    test10:
        li    t0, 0x80
        andi  t2, t0, 0x7F
        li    t3, 0x00
        beq   t2, t3, test11
        j     Fail_Andi_10

    // AND with -1 (all bits set) is identity: 0x5A & -1 = 0x5A
    test11:
        li    t0, 0x5A
        andi  t2, t0, -1
        li    t3, 0x5A
        beq   t2, t3, pass
        j     Fail_Andi_11

    pass:
        j return_andi_test

Fail_Andi_1:
    li   gp, 701
    j    fail

Fail_Andi_2:
    li   gp, 702
    j    fail

Fail_Andi_3:
    li   gp, 703
    j    fail

Fail_Andi_4:
    li   gp, 704
    j    fail

Fail_Andi_5:
    li   gp, 705
    j    fail

Fail_Andi_6:
    li   gp, 706
    j    fail

Fail_Andi_7:
    li   gp, 707
    j    fail

Fail_Andi_8:
    li   gp, 708
    j    fail

Fail_Andi_9:
    li   gp, 709
    j    fail

Fail_Andi_10:
    li   gp, 710
    j    fail

Fail_Andi_11:
    li   gp, 711
    j    fail
