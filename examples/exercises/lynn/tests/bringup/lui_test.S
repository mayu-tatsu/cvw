.extern return_lui_test
.extern fail

    .section .text.init
    .globl lui_test
    .type  lui_test, @function

lui_test:
    // test1: lui basic - loads 20-bit immediate into upper 20 bits, lower 12 = 0
    test1:
        lui  t0, 1              // 0x00001000
        li   t3, 0x00001000
        beq  t0, t3, test2
        j    Fail_Lui_1

    // test2: lui with 0x12345 -> result = 0x12345000
    test2:
        lui  t0, 0x12345
        li   t3, 0x12345000
        beq  t0, t3, test3
        j    Fail_Lui_2

    // test3: lui with 0 -> result = 0
    test3:
        lui  t0, 0
        li   t3, 0
        beq  t0, t3, test4
        j    Fail_Lui_3

    // test4: lui lower 12 bits are always zero
    test4:
        lui  t0, 0xABCDE
        li   t1, 0xFFF          // load mask into register (0xFFF too large for andi)
        and  t1, t0, t1         // mask lower 12 bits
        li   t3, 0
        beq  t1, t3, test5
        j    Fail_Lui_4

    // test5: lui with high bit set in upper 20 (0x80000 -> 0x80000000, negative 32-bit signed)
    test5:
        lui  t0, 0x80000
        li   t3, 0x80000000
        beq  t0, t3, test6
        j    Fail_Lui_5

    // test6: lui max immediate 0xFFFFF -> 0xFFFFF000
    test6:
        lui  t0, 0xFFFFF
        li   t3, 0xFFFFF000
        beq  t0, t3, test7
        j    Fail_Lui_6

    // test7: lui followed by addi to build full 32-bit constant
    //        lui t0, 0x12345; addi t0, t0, 0x678 -> 0x12345678
    test7:
        lui  t0, 0x12345
        addi t0, t0, 0x678
        li   t3, 0x12345678
        beq  t0, t3, test8
        j    Fail_Lui_7

    // test8: lui result does not affect other registers
    test8:
        li   t1, 0xDEAD
        lui  t0, 0x12345
        li   t3, 0xDEAD
        beq  t1, t3, test9
        j    Fail_Lui_8

    // test9: lui with 1 in highest bit of upper 20 (bit 31 of result set)
    test9:
        lui  t0, 0x80001
        li   t3, 0x80001000
        beq  t0, t3, test10
        j    Fail_Lui_9

    // test10: lui x0 has no effect (x0 always 0)
    test10:
        lui  zero, 0x12345
        li   t3, 0
        beq  zero, t3, pass
        j    Fail_Lui_10

    pass:
        j return_lui_test

Fail_Lui_1:
    li   gp, 2701
    j    fail

Fail_Lui_2:
    li   gp, 2702
    j    fail

Fail_Lui_3:
    li   gp, 2703
    j    fail

Fail_Lui_4:
    li   gp, 2704
    j    fail

Fail_Lui_5:
    li   gp, 2705
    j    fail

Fail_Lui_6:
    li   gp, 2706
    j    fail

Fail_Lui_7:
    li   gp, 2707
    j    fail

Fail_Lui_8:
    li   gp, 2708
    j    fail

Fail_Lui_9:
    li   gp, 2709
    j    fail

Fail_Lui_10:
    li   gp, 2710
    j    fail
