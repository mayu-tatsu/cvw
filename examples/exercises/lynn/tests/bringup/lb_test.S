.extern return_lb_test
.extern fail

    .section .text.init
    .globl lb_test
    .type  lb_test, @function

lb_test:
    // Setup: store known byte values to memory via sw, then load with lb/lbu
    // We use the stack pointer area for scratch memory (sp assumed valid)

    // test1: lb - load positive byte (0x7F = 127), sign extended = 0x0000007F
    test1:
        li   t0, 0x7F
        sw   t0, -4(sp)
        lb   t2, -4(sp)
        li   t3, 0x7F
        beq  t2, t3, test2
        j    Fail_Lb_1

    // test2: lb - load negative byte (0xFF = -1 signed), sign extended = 0xFFFFFFFF
    test2:
        li   t0, 0xFF
        sw   t0, -4(sp)
        lb   t2, -4(sp)
        li   t3, -1             // 0xFFFFFFFF sign extended
        beq  t2, t3, test3
        j    Fail_Lb_2

    // test3: lb - load 0x80 (-128 signed), sign extended = 0xFFFFFF80
    test3:
        li   t0, 0x80
        sw   t0, -4(sp)
        lb   t2, -4(sp)
        li   t3, 0xFFFFFF80
        beq  t2, t3, test4
        j    Fail_Lb_3

    // test4: lb - load 0x00 = 0
    test4:
        li   t0, 0x00
        sw   t0, -4(sp)
        lb   t2, -4(sp)
        li   t3, 0
        beq  t2, t3, test5
        j    Fail_Lb_4

    // test5: lb - load byte at positive offset
    test5:
        li   t0, 0x55
        sw   t0, -8(sp)
        lb   t2, -8(sp)
        li   t3, 0x55
        beq  t2, t3, test6
        j    Fail_Lb_5

    // test6: lb only reads lowest byte (store word with upper bytes set, read low byte)
    test6:
        li   t0, 0xAABBCCDD
        sw   t0, -4(sp)
        lb   t2, -4(sp)         // should read 0xDD, sign extended = 0xFFFFFFDD
        li   t3, 0xFFFFFFDD
        beq  t2, t3, test7
        j    Fail_Lb_6

    // test7: lbu - load positive byte (0x7F), zero extended = 0x0000007F
    test7:
        li   t0, 0x7F
        sw   t0, -4(sp)
        lbu  t2, -4(sp)
        li   t3, 0x7F
        beq  t2, t3, test8
        j    Fail_Lb_7

    // test8: lbu - load 0xFF, zero extended = 0x000000FF (NOT sign extended)
    test8:
        li   t0, 0xFF
        sw   t0, -4(sp)
        lbu  t2, -4(sp)
        li   t3, 0xFF           // 255, not -1
        beq  t2, t3, test9
        j    Fail_Lb_8

    // test9: lbu - load 0x80, zero extended = 0x00000080
    test9:
        li   t0, 0x80
        sw   t0, -4(sp)
        lbu  t2, -4(sp)
        li   t3, 0x80           // 128, not -128
        beq  t2, t3, test10
        j    Fail_Lb_9

    // test10: lbu - load 0x00 = 0
    test10:
        li   t0, 0x00
        sw   t0, -4(sp)
        lbu  t2, -4(sp)
        li   t3, 0
        beq  t2, t3, test11
        j    Fail_Lb_10

    // test11: lbu only reads lowest byte, zero extended
    test11:
        li   t0, 0xAABBCCDD
        sw   t0, -4(sp)
        lbu  t2, -4(sp)         // should read 0xDD, zero extended = 0x000000DD
        li   t3, 0xDD
        beq  t2, t3, pass
        j    Fail_Lb_11

    pass:
        j return_lb_test

Fail_Lb_1:
    li   gp, 1901
    j    fail

Fail_Lb_2:
    li   gp, 1902
    j    fail

Fail_Lb_3:
    li   gp, 1903
    j    fail

Fail_Lb_4:
    li   gp, 1904
    j    fail

Fail_Lb_5:
    li   gp, 1905
    j    fail

Fail_Lb_6:
    li   gp, 1906
    j    fail

Fail_Lb_7:
    li   gp, 1907
    j    fail

Fail_Lb_8:
    li   gp, 1908
    j    fail

Fail_Lb_9:
    li   gp, 1909
    j    fail

Fail_Lb_10:
    li   gp, 1910
    j    fail

Fail_Lb_11:
    li   gp, 1911
    j    fail
