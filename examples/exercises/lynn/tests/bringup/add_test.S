// C Runtime entry point
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern return_add_test
.extern fail

    .section .text.init
    .globl add_test
    .type  add_test, @function

add_test:
    test1:
        li   t0, 7
        li   t1, 5
        add  t2, t0, t1
        li   t3, 12            // passing case
        // li   t3, 15         // failing case
        beq  t2, t3, test2
        j Fail_Add_1

    test2:
        li   t0, 19
        li   t1, 23
        add  t2, t0, t1
        li   t3, 42
        beq  t2, t3, test3
        j Fail_Add_2

    // TODO: need to fix test3, test4, etc. as LUI becomes usable on processor
    // Positive overflow (within 12-bit range)
    test3:
        li   t0, 0x7F        // 0x7FF (max 8-bit positive)
        li   t1, 1
        add  t2, t0, t1
        li   t3, 0x80        // 0x800 (overflows to negative in 8-bit)
        beq  t2, t3, test5
        j    Fail_Add_3

    // neg overflow (min_neg-1=max_pos)
    test4:
        li t0, 0x80
        li t1, 0xFF           // 0xFF = -1
        add t2, t0, t1
        li t3, 0x7F
        beq t2, t3, test5
        j Fail_Add_4

    // adding with 0: 2+0=2
    test5:
        li t0, 2
        li t1, 0
        add t2, t0, t1
        beq t2, t0, test6
        j Fail_Add_5

    // neg+pos=pos
    test6:
        li   t0, -10
        li   t1, 25
        add  t2, t0, t1
        li   t3, 15
        beq  t2, t3, test7
        j    Fail_Add_6

    // neg+pos=neg
    test7:
        li   t0, -30
        li   t1, 10
        add  t2, t0, t1
        li   t3, -20
        beq  t2, t3, test8
        j    Fail_Add_7

    // neg+neg
    test8:
        li   t0, -15
        li   t1, -8
        add  t2, t0, t1
        li   t3, -23
        beq  t2, t3, test9
        j    Fail_Add_8

    // increment
    test9:
        li   t0, 99
        li   t1, 1
        add  t2, t0, t1
        li   t3, 100
        beq  t2, t3, test10
        j    Fail_Add_9

    // decrement
    test10:
        li   t0, 100
        li   t1, -1
        add  t2, t0, t1
        li   t3, 99
        beq  t2, t3, test11
        j    Fail_Add_10

    // double the number? should SLL
    test11:
        li   t0, 123
        li   t1, 123
        add  t2, t0, t1
        li   t3, 246
        beq  t2, t3, pass
        j    Fail_Add_11

    pass:
        j return_add_test

Fail_Add_1:
    li   gp, 101
    j    fail

Fail_Add_2:
    li   gp, 102
    j    fail

Fail_Add_3:
    li   gp, 103
    j    fail

Fail_Add_4:
    li   gp, 104
    j    fail

Fail_Add_5:
    li   gp, 105
    j    fail

Fail_Add_6:
    li   gp, 106
    j    fail

Fail_Add_7:
    li   gp, 107
    j    fail

Fail_Add_8:
    li   gp, 108
    j    fail

Fail_Add_9:
    li   gp, 109
    j    fail

Fail_Add_10:
    li   gp, 110
    j    fail

Fail_Add_11:
    li   gp, 111
    j    fail
