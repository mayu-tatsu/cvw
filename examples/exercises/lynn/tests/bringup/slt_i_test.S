.extern return_slt_i_test
.extern fail

    .section .text.init
    .globl slt_i_test
    .type  slt_i_test, @function

slt_i_test:

    #  SLT tests

    # Test 1: rs1 < rs2 (result = 1)
    test1:
        li   t0, 5
        li   t1, 10
        slt  t2, t0, t1
        li   t3, 1
        beq  t2, t3, test2
        j    Fail_Slt_1

    # Test 2: rs1 > rs2 (result = 0)
    test2:
        li   t0, 10
        li   t1, 5
        slt  t2, t0, t1
        beq  t2, x0, test3
        j    Fail_Slt_2

    # Test 3: rs1 == rs2 (result = 0)
    test3:
        li   t0, 7
        li   t1, 7
        slt  t2, t0, t1
        beq  t2, x0, test4
        j    Fail_Slt_3

    # Test 4: negative < positive (result = 1)
    test4:
        li   t0, -1
        li   t1, 1
        slt  t2, t0, t1
        li   t3, 1
        beq  t2, t3, test5
        j    Fail_Slt_4

    # Test 5: positive < negative is false (result = 0)
    test5:
        li   t0, 1
        li   t1, -1
        slt  t2, t0, t1
        beq  t2, x0, test6
        j    Fail_Slt_5

    # Test 6: both negative, rs1 < rs2 (result = 1)
    # -10 < -5
    test6:
        li   t0, -10
        li   t1, -5
        slt  t2, t0, t1
        li   t3, 1
        beq  t2, t3, test7
        j    Fail_Slt_6

    # Test 7: both negative, rs1 > rs2 (result = 0)
    # -5 > -10
    test7:
        li   t0, -5
        li   t1, -10
        slt  t2, t0, t1
        beq  t2, x0, test8
        j    Fail_Slt_7

    # Test 8: compare with zero, rs1 negative (result = 1)
    test8:
        li   t0, -1
        slt  t2, t0, x0
        li   t3, 1
        beq  t2, t3, test9
        j    Fail_Slt_8

    # Test 9: compare with zero, rs1 positive (result = 0)
    test9:
        li   t0, 1
        slt  t2, t0, x0
        beq  t2, x0, test10
        j    Fail_Slt_9

    # Test 10: rs1 == rs2, both same register (result = 0)
    test10:
        li   t0, 99
        slt  t2, t0, t0
        beq  t2, x0, test11
        j    Fail_Slt_10

    # SLTI tests

    # Test 11: rs1 < imm (result = 1)
    test11:
        li   t0, 5
        slti t2, t0, 10
        li   t3, 1
        beq  t2, t3, test12
        j    Fail_Slti_11

    # Test 12: rs1 > imm (result = 0)
    test12:
        li   t0, 10
        slti t2, t0, 5
        beq  t2, x0, test13
        j    Fail_Slti_12

    # Test 13: rs1 == imm (result = 0)
    test13:
        li   t0, 7
        slti t2, t0, 7
        beq  t2, x0, test14
        j    Fail_Slti_13

    # Test 14: negative rs1 < positive imm (result = 1)
    test14:
        li   t0, -1
        slti t2, t0, 1
        li   t3, 1
        beq  t2, t3, test15
        j    Fail_Slti_14

    # Test 15: positive rs1, negative imm (result = 0)
    test15:
        li   t0, 1
        slti t2, t0, -1
        beq  t2, x0, test16
        j    Fail_Slti_15

    # Test 16: both negative, rs1 < imm (result = 1)
    # -10 < -5
    test16:
        li   t0, -10
        slti t2, t0, -5
        li   t3, 1
        beq  t2, t3, test17
        j    Fail_Slti_16

    # Test 17: both negative, rs1 > imm (result = 0)
    # -5 > -10
    test17:
        li   t0, -5
        slti t2, t0, -10
        beq  t2, x0, test18
        j    Fail_Slti_17

    # Test 18: rs1 negative, imm = 0 (result = 1)
    test18:
        li   t0, -1
        slti t2, t0, 0
        li   t3, 1
        beq  t2, t3, test19
        j    Fail_Slti_18

    # Test 19: rs1 = 0, imm positive (result = 1)
    test19:
        li   t0, 0
        slti t2, t0, 1
        li   t3, 1
        beq  t2, t3, test20
        j    Fail_Slti_19

    # Test 20: rs1 = 0, imm = 0 (result = 0)
    test20:
        li   t0, 0
        slti t2, t0, 0
        beq  t2, x0, pass
        j    Fail_Slti_20

    pass:
        j    return_slt_i_test

Fail_Slt_1:
    li   gp, 1301
    j    fail

Fail_Slt_2:
    li   gp, 1302
    j    fail

Fail_Slt_3:
    li   gp, 1303
    j    fail

Fail_Slt_4:
    li   gp, 1304
    j    fail

Fail_Slt_5:
    li   gp, 1305
    j    fail

Fail_Slt_6:
    li   gp, 1306
    j    fail

Fail_Slt_7:
    li   gp, 1307
    j    fail

Fail_Slt_8:
    li   gp, 1308
    j    fail

Fail_Slt_9:
    li   gp, 1309
    j    fail

Fail_Slt_10:
    li   gp, 1310
    j    fail

Fail_Slti_11:
    li   gp, 1311
    j    fail

Fail_Slti_12:
    li   gp, 1312
    j    fail

Fail_Slti_13:
    li   gp, 1313
    j    fail

Fail_Slti_14:
    li   gp, 1314
    j    fail

Fail_Slti_15:
    li   gp, 1315
    j    fail

Fail_Slti_16:
    li   gp, 1316
    j    fail

Fail_Slti_17:
    li   gp, 1317
    j    fail

Fail_Slti_18:
    li   gp, 1318
    j    fail

Fail_Slti_19:
    li   gp, 1319
    j    fail

Fail_Slti_20:
    li   gp, 1320
    j    fail
