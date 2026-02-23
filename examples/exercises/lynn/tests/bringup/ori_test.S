.extern return_ori_test
.extern fail

    .section .text.init
    .globl ori_test
    .type  ori_test, @function

ori_test:
    // complementary nibbles: 0x0F | 0xF0 = 0xFF
    test1:
        li    t0, 0x0F
        ori   t2, t0, 0xF0
        li    t3, 0xFF
        beq   t2, t3, test2
        j     Fail_Ori_1

    // complementary bytes: 0x33 | 0xCC = 0xFF
    test2:
        li    t0, 0x33      // 00110011
        ori   t2, t0, 0xCC  // 11001100 -> 11111111
        li    t3, 0xFF
        beq   t2, t3, test3
        j     Fail_Ori_2

    // identity: 0xAB | 0x00 = 0xAB
    test3:
        li    t0, 0xAB
        ori   t2, t0, 0
        li    t3, 0xAB
        beq   t2, t3, test4
        j     Fail_Ori_3

    // OR with all ones stays all ones: 0x00 | 0xFF = 0xFF
    test4:
        li    t0, 0x00
        ori   t2, t0, 0xFF
        li    t3, 0xFF
        beq   t2, t3, test5
        j     Fail_Ori_4

    // overlapping bits (no new bits set): 0x0F | 0x0F = 0x0F
    test5:
        li    t0, 0x0F
        ori   t2, t0, 0x0F
        li    t3, 0x0F
        beq   t2, t3, test6
        j     Fail_Ori_5

    // partial overlap: 0x36 | 0x5A = 0x7E
    // 0x36 = 00110110
    // 0x5A = 01011010
    // 0x7E = 01111110
    test6:
        li    t0, 0x36
        ori   t2, t0, 0x5A
        li    t3, 0x7E
        beq   t2, t3, test7
        j     Fail_Ori_6

    // single bit set: 0x40 | 0x08 = 0x48
    test7:
        li    t0, 0x40
        ori   t2, t0, 0x08
        li    t3, 0x48
        beq   t2, t3, test8
        j     Fail_Ori_7

    // negative src: -1 | 0 = -1
    test8:
        li    t0, -1
        ori   t2, t0, 0
        li    t3, -1
        beq   t2, t3, test9
        j     Fail_Ori_8

    // annihilator: any | -1 = -1 (imm = -1 = 0xFFF sign-extended)
    test9:
        li    t0, 0x55
        ori   t2, t0, -1
        li    t3, -1
        beq   t2, t3, test10
        j     Fail_Ori_9

    // OR from zero: 0 | imm = imm
    test10:
        li    t0, 0
        ori   t2, t0, 0x6B
        li    t3, 0x6B
        beq   t2, t3, test11
        j     Fail_Ori_10

    // negative imm (-1 is 0xFFF): 0x55 | -2 = -1
    // -2 = 0xFFFF...FE, so 0x55 | -2 = 0xFFFF...FF = -1
    test11:
        li    t0, 0x55
        ori   t2, t0, -2
        li    t3, -1
        beq   t2, t3, pass
        j     Fail_Ori_11

    pass:
        j return_ori_test

Fail_Ori_1:
    li   gp, 601
    j    fail

Fail_Ori_2:
    li   gp, 602
    j    fail

Fail_Ori_3:
    li   gp, 603
    j    fail

Fail_Ori_4:
    li   gp, 604
    j    fail

Fail_Ori_5:
    li   gp, 605
    j    fail

Fail_Ori_6:
    li   gp, 606
    j    fail

Fail_Ori_7:
    li   gp, 607
    j    fail

Fail_Ori_8:
    li   gp, 608
    j    fail

Fail_Ori_9:
    li   gp, 609
    j    fail

Fail_Ori_10:
    li   gp, 610
    j    fail

Fail_Ori_11:
    li   gp, 611
    j    fail
