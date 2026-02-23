// C Runtime entry point
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_and_test
.extern fail

    .section .text.init
    .globl and_test
    .type  and_test, @function

and_test:

    // alternating bits
    test1:
        li   t0, 0x55
        li   t1, 0xAA
        and  t2, t0, t1
        li   t3, 0x00
        beq  t2, t3, test2
        j Fail_And_1

    test2:
        li   t0, 0x3C       // 00111100
        li   t1, 0xC3       // 11000011
        and  t2, t0, t1     // = 00000000
        li   t3, 0x00
        beq  t2, t3, test3
        j Fail_And_2

    // AND w/ all 1s, keep as is
    test3:
        li t0, 0x39
        li t1, 0xFF
        and t2, t0, t1
        li t3, 0x39
        beq t2, t3, test4
        j Fail_And_3


    // AND w/ all 0s, all 0 output
    test4:
        li t0, 0xB9
        li t1, 0x00
        and t2, t0, t1
        li t3, 0x00
        beq t2, t3, test5
        j Fail_And_4

    // AND the same two things, all same output
    test5:
        li t0, 0x6C
        and t1, t0, t0
        li t2, 0x6C
        beq t1, t2, test6
        j Fail_And_5

    // mask lower bits
    test6:
        li t0, 0x52
        li t1, 0x0F
        and t2, t0, t1
        li t3, 0x02
        beq t2, t3, test7
        j Fail_And_6

    // mask upper bits
    test7:
        li t0, 0x12
        li t1, 0xF0
        and t2, t0, t1
        li t3, 0x10
        beq t2, t3, test8
        j Fail_And_7

    // clearing a bit
    test8:
        li   t0, 0xFF
        li   t1, 0xDF     // all 1s except bit 5
        and  t2, t0, t1
        li   t3, 0xDF
        beq  t2, t3, test9
        j    Fail_And_8

    // neg values, ensure sign bit preservation for 2s comp
    test9:
        li   t0, 0x80           // min negative (smallest possible number)
        li   t1, 0x81           // 1 bigger than 0x8000000, still neg
        and  t2, t0, t1
        li   t3, 0x80           // sign bit preserved ONLY
        beq  t2, t3, test10
        j    Fail_And_9

    // power of 2s
    test10:
        li   t0, 0x80           // 128, power of 2
        li   t1, 0x7F           // 127
        and  t2, t0, t1
        li   t3, 0x00           // outputs 0 for power of 2
        beq  t2, t3, pass
        j    Fail_And_10

    pass:
        j return_and_test

Fail_And_1:
    li   gp, 301
    j    fail

Fail_And_2:
    li   gp, 302
    j    fail

Fail_And_3:
    li   gp, 303
    j    fail

Fail_And_4:
    li   gp, 304
    j    fail

Fail_And_5:
    li   gp, 305
    j    fail

Fail_And_6:
    li   gp, 306
    j    fail

Fail_And_7:
    li   gp, 307
    j    fail

Fail_And_8:
    li   gp, 308
    j    fail

Fail_And_9:
    li   gp, 309
    j    fail

Fail_And_10:
    li   gp, 310
    j    fail
