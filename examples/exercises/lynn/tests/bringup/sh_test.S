.extern return_sh_test
.extern fail

    .section .text.init
    .globl sh_test
    .type  sh_test, @function

sh_test:
    // test1: sh stores lowest halfword; read back with lhu to verify
    test1:
        li   t0, 0x1234
        sh   t0, -4(sp)
        lhu  t2, -4(sp)
        li   t3, 0x1234
        beq  t2, t3, test2
        j    Fail_Sh_1

    // test2: sh stores 0xFFFF
    test2:
        li   t0, 0xFFFF
        sh   t0, -4(sp)
        lhu  t2, -4(sp)
        li   t3, 0xFFFF
        beq  t2, t3, test3
        j    Fail_Sh_2

    // test3: sh stores 0x0000
    test3:
        li   t0, 0x0000
        sh   t0, -4(sp)
        lhu  t2, -4(sp)
        li   t3, 0x0000
        beq  t2, t3, test4
        j    Fail_Sh_3

    // test4: sh only writes low 16 bits, does not disturb upper halfword
    //        little-endian: sw 0xAABBCCDD -> addr: [DD][CC][BB][AA]
    //        sh 0x9999 to same addr -> [99][99][BB][AA] -> word = 0xAABB9999
    test4:
        li   t0, 0xAABBCCDD
        sw   t0, -4(sp)
        li   t1, 0x9999
        sh   t1, -4(sp)
        lw   t2, -4(sp)
        li   t3, 0xAABB9999
        beq  t2, t3, test5
        j    Fail_Sh_4

    // test5: sh discards upper 16 bits of source register
    test5:
        li   t0, 0xAABBCCDD     // only 0xCCDD should be stored
        sh   t0, -4(sp)
        lhu  t2, -4(sp)
        li   t3, 0xCCDD
        beq  t2, t3, test6
        j    Fail_Sh_5

    // test6: sh then lh sign extension (store 0x8000, lh reads -32768)
    test6:
        li   t0, 0x8000
        sh   t0, -4(sp)
        lh   t2, -4(sp)
        li   t3, 0xFFFF8000
        beq  t2, t3, test7
        j    Fail_Sh_6

    // test7: sh stores to positive offset
    test7:
        li   t0, 0x5A5A
        sh   t0, -8(sp)
        lhu  t2, -8(sp)
        li   t3, 0x5A5A
        beq  t2, t3, test8
        j    Fail_Sh_7

    // test8: sh stores max positive halfword 0x7FFF
    test8:
        li   t0, 0x7FFF
        sh   t0, -4(sp)
        lhu  t2, -4(sp)
        li   t3, 0x7FFF
        beq  t2, t3, test9
        j    Fail_Sh_8

    // test9: sh stores 0x0001
    test9:
        li   t0, 0x0001
        sh   t0, -4(sp)
        lhu  t2, -4(sp)
        li   t3, 0x0001
        beq  t2, t3, test10
        j    Fail_Sh_9

    // test10: sh then lhu no sign extension (0xABCD stored, lhu reads 0xABCD not negative)
    test10:
        li   t0, 0xABCD
        sh   t0, -4(sp)
        lhu  t2, -4(sp)
        li   t3, 0xABCD
        beq  t2, t3, test11
        j    Fail_Sh_10

    // test11: consecutive sh to adjacent halfword addresses
    test11:
        li   t0, 0x1111
        sh   t0, -4(sp)
        li   t0, 0x2222
        sh   t0, -2(sp)
        lhu  t2, -4(sp)
        li   t3, 0x1111
        bne  t2, t3, Fail_Sh_11
        lhu  t2, -2(sp)
        li   t3, 0x2222
        beq  t2, t3, pass
        j    Fail_Sh_11

    pass:
        j return_sh_test

Fail_Sh_1:
    li   gp, 2201
    j    fail

Fail_Sh_2:
    li   gp, 2202
    j    fail

Fail_Sh_3:
    li   gp, 2203
    j    fail

Fail_Sh_4:
    li   gp, 2204
    j    fail

Fail_Sh_5:
    li   gp, 2205
    j    fail

Fail_Sh_6:
    li   gp, 2206
    j    fail

Fail_Sh_7:
    li   gp, 2207
    j    fail

Fail_Sh_8:
    li   gp, 2208
    j    fail

Fail_Sh_9:
    li   gp, 2209
    j    fail

Fail_Sh_10:
    li   gp, 2210
    j    fail

Fail_Sh_11:
    li   gp, 2211
    j    fail
