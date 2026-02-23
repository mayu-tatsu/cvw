.extern return_sb_test
.extern fail

    .section .text.init
    .globl sb_test
    .type  sb_test, @function

sb_test:
    // test1: sb stores only lowest byte; read back with lbu to verify
    test1:
        li   t0, 0x42
        sb   t0, -4(sp)
        lbu  t2, -4(sp)
        li   t3, 0x42
        beq  t2, t3, test2
        j    Fail_Sb_1

    // test2: sb stores 0xFF (only low byte stored)
    test2:
        li   t0, 0xFF
        sb   t0, -4(sp)
        lbu  t2, -4(sp)
        li   t3, 0xFF
        beq  t2, t3, test3
        j    Fail_Sb_2

    // test3: sb stores 0x00
    test3:
        li   t0, 0x00
        sb   t0, -4(sp)
        lbu  t2, -4(sp)
        li   t3, 0x00
        beq  t2, t3, test4
        j    Fail_Sb_3

    // test4: sb only writes lowest byte, does not disturb adjacent bytes
    //        store 0xAABBCCDD as a word, then sb 0x99 to byte 0, read back word
    test4:
        li   t0, 0xAABBCCDD
        sw   t0, -4(sp)
        li   t1, 0x99
        sb   t1, -4(sp)         // overwrite lowest byte with 0x99
        lw   t2, -4(sp)
        li   t3, 0xAABBCC99     // only low byte changed
        beq  t2, t3, test5
        j    Fail_Sb_4

    // test5: sb stores value using positive offset
    test5:
        li   t0, 0x7E
        sb   t0, -8(sp)
        lbu  t2, -8(sp)
        li   t3, 0x7E
        beq  t2, t3, test6
        j    Fail_Sb_5

    // test6: sb - store to second byte position (offset+1)
    test6:
        li   t0, 0xAABBCCDD
        sw   t0, -4(sp)
        li   t1, 0x11
        sb   t1, -3(sp)         // byte 1 (offset+1 from base)
        lw   t2, -4(sp)
        li   t3, 0xAABBCCDD     // expect byte 1 changed: DD stays, byte1 = 0x11 -> 0xAABB11DD
        // actually byte layout depends on endianness; assuming little-endian:
        // address -4: byte0=0xDD, byte-3: byte1=0xCC, byte-2: byte2=0xBB, byte-1: byte3=0xAA
        // sb to -3(sp) writes byte1 -> result: 0xAABB11DD
        li   t3, 0xAABB11DD
        beq  t2, t3, test7
        j    Fail_Sb_6

    // test7: sb discards upper bytes of source register (store 0xAABBCCDD, only 0xDD written)
    test7:
        li   t0, 0xAABBCCDD
        sb   t0, -4(sp)         // only low byte 0xDD stored
        lbu  t2, -4(sp)
        li   t3, 0xDD
        beq  t2, t3, test8
        j    Fail_Sb_7

    // test8: sb then lb sign extension check (store 0x80, lb reads -128)
    test8:
        li   t0, 0x80
        sb   t0, -4(sp)
        lb   t2, -4(sp)
        li   t3, 0xFFFFFF80     // sign extended -128
        beq  t2, t3, test9
        j    Fail_Sb_8

    // test9: sb stores 0x01
    test9:
        li   t0, 0x01
        sb   t0, -4(sp)
        lbu  t2, -4(sp)
        li   t3, 0x01
        beq  t2, t3, test10
        j    Fail_Sb_9

    // test10: sb stores 0x7F (max positive signed byte)
    test10:
        li   t0, 0x7F
        sb   t0, -4(sp)
        lbu  t2, -4(sp)
        li   t3, 0x7F
        beq  t2, t3, test11
        j    Fail_Sb_10

    // test11: consecutive sb writes to consecutive addresses
    test11:
        li   t0, 0xAA
        sb   t0, -4(sp)
        li   t0, 0xBB
        sb   t0, -3(sp)
        lbu  t2, -4(sp)
        li   t3, 0xAA
        bne  t2, t3, Fail_Sb_11
        lbu  t2, -3(sp)
        li   t3, 0xBB
        beq  t2, t3, pass
        j    Fail_Sb_11

    pass:
        j return_sb_test

Fail_Sb_1:
    li   gp, 2101
    j    fail

Fail_Sb_2:
    li   gp, 2102
    j    fail

Fail_Sb_3:
    li   gp, 2103
    j    fail

Fail_Sb_4:
    li   gp, 2104
    j    fail

Fail_Sb_5:
    li   gp, 2105
    j    fail

Fail_Sb_6:
    li   gp, 2106
    j    fail

Fail_Sb_7:
    li   gp, 2107
    j    fail

Fail_Sb_8:
    li   gp, 2108
    j    fail

Fail_Sb_9:
    li   gp, 2109
    j    fail

Fail_Sb_10:
    li   gp, 2110
    j    fail

Fail_Sb_11:
    li   gp, 2111
    j    fail
