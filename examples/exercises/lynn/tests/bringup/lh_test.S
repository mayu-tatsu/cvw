.extern return_lh_test
.extern fail

    .section .text.init
    .globl lh_test
    .type  lh_test, @function

lh_test:
    // test1: lh - load positive halfword (0x7FFF = 32767), sign extended = 0x00007FFF
    test1:
        li   t0, 0x7FFF
        sw   t0, -4(sp)
        lh   t2, -4(sp)
        li   t3, 0x7FFF
        beq  t2, t3, test2
        j    Fail_Lh_1

    // test2: lh - load 0xFFFF (-1 signed), sign extended = 0xFFFFFFFF
    test2:
        li   t0, 0xFFFF
        sw   t0, -4(sp)
        lh   t2, -4(sp)
        li   t3, -1
        beq  t2, t3, test3
        j    Fail_Lh_2

    // test3: lh - load 0x8000 (-32768 signed), sign extended = 0xFFFF8000
    test3:
        li   t0, 0x8000
        sw   t0, -4(sp)
        lh   t2, -4(sp)
        li   t3, 0xFFFF8000
        beq  t2, t3, test4
        j    Fail_Lh_3

    // test4: lh - load 0x0000 = 0
    test4:
        li   t0, 0x0000
        sw   t0, -4(sp)
        lh   t2, -4(sp)
        li   t3, 0
        beq  t2, t3, test5
        j    Fail_Lh_4

    // test5: lh reads lower 16 bits of stored word
    test5:
        li   t0, 0xAABB1234
        sw   t0, -4(sp)
        lh   t2, -4(sp)         // lower halfword = 0x1234, sign extended = 0x00001234
        li   t3, 0x1234
        beq  t2, t3, test6
        j    Fail_Lh_5

    // test6: lh reads lower 16 bits, sign extends when high bit set
    test6:
        li   t0, 0xAABBABCD
        sw   t0, -4(sp)
        lh   t2, -4(sp)         // lower halfword = 0xABCD, sign extended = 0xFFFFABCD
        li   t3, 0xFFFFABCD
        beq  t2, t3, test7
        j    Fail_Lh_6

    // test7: lhu - load 0x7FFF, zero extended = 0x00007FFF
    test7:
        li   t0, 0x7FFF
        sw   t0, -4(sp)
        lhu  t2, -4(sp)
        li   t3, 0x7FFF
        beq  t2, t3, test8
        j    Fail_Lh_7

    // test8: lhu - load 0xFFFF, zero extended = 0x0000FFFF (NOT -1)
    test8:
        li   t0, 0xFFFF
        sw   t0, -4(sp)
        lhu  t2, -4(sp)
        li   t3, 0xFFFF         // 65535, not -1
        beq  t2, t3, test9
        j    Fail_Lh_8

    // test9: lhu - load 0x8000, zero extended = 0x00008000
    test9:
        li   t0, 0x8000
        sw   t0, -4(sp)
        lhu  t2, -4(sp)
        li   t3, 0x8000         // 32768, not -32768
        beq  t2, t3, test10
        j    Fail_Lh_9

    // test10: lhu - load 0x0000 = 0
    test10:
        li   t0, 0x0000
        sw   t0, -4(sp)
        lhu  t2, -4(sp)
        li   t3, 0
        beq  t2, t3, test11
        j    Fail_Lh_10

    // test11: lhu reads lower 16 bits, no sign extension
    test11:
        li   t0, 0xAABBABCD
        sw   t0, -4(sp)
        lhu  t2, -4(sp)         // lower halfword = 0xABCD, zero extended = 0x0000ABCD
        li   t3, 0xABCD
        beq  t2, t3, pass
        j    Fail_Lh_11

    pass:
        j return_lh_test

Fail_Lh_1:
    li   gp, 2001
    j    fail

Fail_Lh_2:
    li   gp, 2002
    j    fail

Fail_Lh_3:
    li   gp, 2003
    j    fail

Fail_Lh_4:
    li   gp, 2004
    j    fail

Fail_Lh_5:
    li   gp, 2005
    j    fail

Fail_Lh_6:
    li   gp, 2006
    j    fail

Fail_Lh_7:
    li   gp, 2007
    j    fail

Fail_Lh_8:
    li   gp, 2008
    j    fail

Fail_Lh_9:
    li   gp, 2009
    j    fail

Fail_Lh_10:
    li   gp, 2010
    j    fail

Fail_Lh_11:
    li   gp, 2011
    j    fail
