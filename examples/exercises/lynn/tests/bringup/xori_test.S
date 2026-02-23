.extern return_xori_test
.extern fail

    .section .text.init
    .globl xori_test
    .type  xori_test, @function

xori_test:
    // complementary nibbles: 0x0F ^ 0xF0 = 0xFF
    test1:
        li    t0, 0x0F
        xori  t2, t0, 0xF0
        li    t3, 0xFF
        beq   t2, t3, test2
        j     Fail_Xori_1

    // complementary bytes: 0x33 ^ 0xCC = 0xFF
    test2:
        li    t0, 0x33      // 00110011
        xori  t2, t0, 0xCC  // 11001100 -> 11111111
        li    t3, 0xFF
        beq   t2, t3, test3
        j     Fail_Xori_2

    // identity: 0xAB ^ 0x00 = 0xAB
    test3:
        li    t0, 0xAB
        xori  t2, t0, 0
        li    t3, 0xAB
        beq   t2, t3, test4
        j     Fail_Xori_3

    // XOR with all ones is bitwise NOT: 0xAA ^ 0xFF = 0x55
    test4:
        li    t0, 0xAA
        xori  t2, t0, 0xFF
        li    t3, 0x55
        beq   t2, t3, test5
        j     Fail_Xori_4

    // partial overlap: 0x36 ^ 0x5A = 0x6C
    test5:
        li    t0, 0x36      // 00110110
        xori  t2, t0, 0x5A  // 01011010 -> 01101100
        li    t3, 0x6C
        beq   t2, t3, test6
        j     Fail_Xori_5

    // toggle a specific bit: 0xFF ^ 0x08 = 0xF7
    test6:
        li    t0, 0xFF
        xori  t2, t0, 0x08
        li    t3, 0xF7
        beq   t2, t3, test7
        j     Fail_Xori_6

    // XOR from zero: 0 ^ imm = imm
    test7:
        li    t0, 0
        xori  t2, t0, 0x6B
        li    t3, 0x6B
        beq   t2, t3, test8
        j     Fail_Xori_7

    // negative src: -1 ^ 0 = -1
    test8:
        li    t0, -1
        xori  t2, t0, 0
        li    t3, -1
        beq   t2, t3, test9
        j     Fail_Xori_8

    // bitwise NOT via xori -1: 0x55 ^ -1 = -86
    test9:
        li    t0, 0x55
        xori  t2, t0, -1
        li    t3, -86        // ~0x55 = 0xFFFFFFAA = -86
        beq   t2, t3, test10
        j     Fail_Xori_9

    // double XOR restores original: (a ^ imm) ^ imm = a
    test10:
        li    t0, 0x3C
        xori  t2, t0, 0xA5  // encrypt
        xori  t2, t2, 0xA5  // decrypt, should restore 0x3C
        li    t3, 0x3C
        beq   t2, t3, test11
        j     Fail_Xori_10

    // negative imm: 0x55 ^ -2 = ~(0x55 ^ 1) -- tests sign-extended imm
    // -2 = 0xFFFF...FE, so 0x55 ^ -2 = 0xFFFF...AB = -85
    test11:
        li    t0, 0x55
        xori  t2, t0, -2
        li    t3, -85
        beq   t2, t3, pass
        j     Fail_Xori_11

    pass:
        j return_xori_test

Fail_Xori_1:
    li   gp, 1001
    j    fail

Fail_Xori_2:
    li   gp, 1002
    j    fail

Fail_Xori_3:
    li   gp, 1003
    j    fail

Fail_Xori_4:
    li   gp, 1004
    j    fail

Fail_Xori_5:
    li   gp, 1005
    j    fail

Fail_Xori_6:
    li   gp, 1006
    j    fail

Fail_Xori_7:
    li   gp, 1007
    j    fail

Fail_Xori_8:
    li   gp, 1008
    j    fail

Fail_Xori_9:
    li   gp, 1009
    j    fail

Fail_Xori_10:
    li   gp, 1010
    j    fail

Fail_Xori_11:
    li   gp, 1011
    j    fail
