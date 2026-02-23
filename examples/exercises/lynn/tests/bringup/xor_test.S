.extern return_xor_test
.extern fail

    .section .text.init
    .globl xor_test
    .type  xor_test, @function

xor_test:
    // complementary nibbles: 0x0F ^ 0xF0 = 0xFF
    test1:
        li   t0, 0x0F
        li   t1, 0xF0
        xor  t2, t0, t1
        li   t3, 0xFF
        beq  t2, t3, test2
        j    Fail_Xor_1

    // complementary bytes: 0x33 ^ 0xCC = 0xFF
    test2:
        li   t0, 0x33      // 00110011
        li   t1, 0xCC      // 11001100
        xor  t2, t0, t1    // 11111111
        li   t3, 0xFF
        beq  t2, t3, test3
        j    Fail_Xor_2

    // XOR with 0 is identity: 0xAB ^ 0x00 = 0xAB
    test3:
        li   t0, 0xAB
        li   t1, 0
        xor  t2, t0, t1
        li   t3, 0xAB
        beq  t2, t3, test4
        j    Fail_Xor_3

    // XOR with itself is 0: 0x5A ^ 0x5A = 0x00
    test4:
        li   t0, 0x5A
        xor  t2, t0, t0
        li   t3, 0x00
        beq  t2, t3, test5
        j    Fail_Xor_4

    // XOR with all ones is bitwise NOT: 0xAA ^ 0xFF = 0x55
    test5:
        li   t0, 0xAA
        li   t1, 0xFF
        xor  t2, t0, t1
        li   t3, 0x55
        beq  t2, t3, test6
        j    Fail_Xor_5

    // partial overlap: 0x36 ^ 0x5A = 0x6C
    // 0x36 = 00110110
    // 0x5A = 01011010
    // 0x6C = 01101100
    test6:
        li   t0, 0x36
        li   t1, 0x5A
        xor  t2, t0, t1
        li   t3, 0x6C
        beq  t2, t3, test7
        j    Fail_Xor_6

    // toggle a specific bit: 0xFF ^ 0x08 = 0xF7 (clears bit 3)
    test7:
        li   t0, 0xFF
        li   t1, 0x08
        xor  t2, t0, t1
        li   t3, 0xF7
        beq  t2, t3, test8
        j    Fail_Xor_7

    // commutativity: a^b == b^a
    // 0x71 ^ 0x1E = 0x6F, check both orderings
    test8:
        li   t0, 0x71
        li   t1, 0x1E
        xor  t2, t0, t1    // 0x71 ^ 0x1E
        xor  t3, t1, t0    // 0x1E ^ 0x71
        beq  t2, t3, test9
        j    Fail_Xor_8

    // negative numbers: -1 ^ 0 = -1
    test9:
        li   t0, -1
        li   t1, 0
        xor  t2, t0, t1
        li   t3, -1
        beq  t2, t3, test10
        j    Fail_Xor_9

    // XOR with -1 is bitwise NOT: 0x55 ^ -1 = 0xFFFF...AA = -171
    test10:
        li   t0, 0x55
        li   t1, -1
        xor  t2, t0, t1
        li   t3, -86        // ~0x55 = 0xFFFFFFAA = -86
        beq  t2, t3, test11
        j    Fail_Xor_10

    // double XOR restores original: (a^b)^b = a
    test11:
        li   t0, 0x3C
        li   t1, 0xA5
        xor  t2, t0, t1    // encrypted
        xor  t2, t2, t1    // decrypted, should restore t0
        beq  t2, t0, pass
        j    Fail_Xor_11

    pass:
        j return_xor_test

Fail_Xor_1:
    li   gp, 901
    j    fail

Fail_Xor_2:
    li   gp, 902
    j    fail

Fail_Xor_3:
    li   gp, 903
    j    fail

Fail_Xor_4:
    li   gp, 904
    j    fail

Fail_Xor_5:
    li   gp, 905
    j    fail

Fail_Xor_6:
    li   gp, 906
    j    fail

Fail_Xor_7:
    li   gp, 907
    j    fail

Fail_Xor_8:
    li   gp, 908
    j    fail

Fail_Xor_9:
    li   gp, 909
    j    fail

Fail_Xor_10:
    li   gp, 910
    j    fail

Fail_Xor_11:
    li   gp, 911
    j    fail
