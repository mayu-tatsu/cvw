// C Runtime entry point
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_or_test
.extern fail

    .section .text.init
    .globl or_test
    .type  or_test, @function

or_test:
    // complementary nibbles: 0x0F | 0xF0 = 0xFF
    test1:
        li   t0, 0x0F
        li   t1, 0xF0
        or   t2, t0, t1
        li   t3, 0xFF
        beq  t2, t3, test2
        j    Fail_Or_1

    // complementary bytes: 0x33 | 0xCC = 0xFF
    test2:
        li   t0, 0x33      // 00110011
        li   t1, 0xCC      // 11001100
        or   t2, t0, t1    // 11111111
        li   t3, 0xFF
        beq  t2, t3, test3
        j    Fail_Or_2

    // OR with 0 is identity: 0xAB | 0x00 = 0xAB
    test3:
        li   t0, 0xAB
        li   t1, 0
        or   t2, t0, t1
        li   t3, 0xAB
        beq  t2, t3, test4
        j    Fail_Or_3

    // OR with itself is itself: 0x5A | 0x5A = 0x5A
    test4:
        li   t0, 0x5A
        or   t2, t0, t0
        li   t3, 0x5A
        beq  t2, t3, test5
        j    Fail_Or_4

    // OR with all ones stays all ones: 0x00 | 0xFF = 0xFF
    test5:
        li   t0, 0x00
        li   t1, 0xFF
        or   t2, t0, t1
        li   t3, 0xFF
        beq  t2, t3, test6
        j    Fail_Or_5

    // overlapping bits: 0x0F | 0x0F = 0x0F (no new bits set)
    test6:
        li   t0, 0x0F
        li   t1, 0x0F
        or   t2, t0, t1
        li   t3, 0x0F
        beq  t2, t3, test7
        j    Fail_Or_6

    // partial overlap: 0x36 | 0x5A = 0x7E
    // 0x36 = 00110110
    // 0x5A = 01011010
    // 0x7E = 01111110
    test7:
        li   t0, 0x36
        li   t1, 0x5A
        or   t2, t0, t1
        li   t3, 0x7E
        beq  t2, t3, test8
        j    Fail_Or_7

    // single bit set: 0x01 | 0x80 = 0x81
    test8:
        li   t0, 0x01
        li   t1, 0x80
        or   t2, t0, t1
        li   t3, 0x81
        beq  t2, t3, test9
        j    Fail_Or_8

    // negative numbers (sign bit): -1 | 0 = -1
    test9:
        li   t0, -1
        li   t1, 0
        or   t2, t0, t1
        li   t3, -1
        beq  t2, t3, test10
        j    Fail_Or_9

    // OR with negative: any | -1 = -1 (all bits set)
    test10:
        li   t0, 0x55
        li   t1, -1
        or   t2, t0, t1
        li   t3, -1
        beq  t2, t3, test11
        j    Fail_Or_10

    // setting a specific bit: 0x40 | 0x08 = 0x48
    test11:
        li   t0, 0x40
        li   t1, 0x08
        or   t2, t0, t1
        li   t3, 0x48
        beq  t2, t3, pass
        j    Fail_Or_11

    pass:
        j return_or_test

Fail_Or_1:
    li   gp, 201
    j    fail

Fail_Or_2:
    li   gp, 202
    j    fail

Fail_Or_3:
    li   gp, 203
    j    fail

Fail_Or_4:
    li   gp, 204
    j    fail

Fail_Or_5:
    li   gp, 205
    j    fail

Fail_Or_6:
    li   gp, 206
    j    fail

Fail_Or_7:
    li   gp, 207
    j    fail

Fail_Or_8:
    li   gp, 208
    j    fail

Fail_Or_9:
    li   gp, 209
    j    fail

Fail_Or_10:
    li   gp, 210
    j    fail

Fail_Or_11:
    li   gp, 211
    j    fail
