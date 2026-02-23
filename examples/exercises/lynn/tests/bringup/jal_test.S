.extern return_jal_test
.extern fail

    .section .text.init
    .globl jal_test
    .type  jal_test, @function

jal_test:
    // test1: basic jal - jumps to target, skips the j Fail immediately after
    test1:
        jal  t0, jal_target_1
        j    Fail_Jal_1             // skipped if jump taken
    jal_target_1:
        j    test2

    // test2: jal stores PC+4 in rd
    // jal_ret_addr_2 must sit at PC+4 of the jal — immediately after it, no instructions between.
    // la expands to 2 instructions so it goes BEFORE the jal.
    test2:
        la   t1, jal_ret_addr_2     // t1 = expected return address
        jal  t0, jal_target_2       // t0 = PC+4 = address of jal_ret_addr_2
    jal_ret_addr_2:                 // <- must be exactly here (PC+4 of jal above)
        beq  t0, t1, test3
        j    Fail_Jal_2
    jal_target_2:
        jalr zero, t0, 0            // return to jal_ret_addr_2

    // test3: jal with x0 as rd discards return address and just jumps
    test3:
        jal  zero, jal_target_3
        j    Fail_Jal_3
    jal_target_3:
        j    test4

    // test4: jal does not modify registers other than rd
    test4:
        li   t1, 0xABCD
        li   t2, 0x1234
        jal  t0, jal_target_4
    jal_ret_4:
        li   t3, 0xABCD
        beq  t1, t3, test4_check2
        j    Fail_Jal_4
    test4_check2:
        li   t3, 0x1234
        beq  t2, t3, test5
        j    Fail_Jal_4
    jal_target_4:
        jalr zero, t0, 0

    // test5: jal with ra as rd - ra holds correct return address
    test5:
        la   t1, jal_ret_addr_5
        jal  ra, jal_target_5
    jal_ret_addr_5:                 // <- PC+4 of jal above
        beq  ra, t1, test6
        j    Fail_Jal_5
    jal_target_5:
        jalr zero, ra, 0

    // test6: rd != zero after jal (sanity that rd was written)
    test6:
        jal  t0, jal_target_6
    jal_ret_6:
        beq  t0, zero, Fail_Jal_6
        j    test7
    jal_target_6:
        jalr zero, t0, 0

    // test7: two sequential jals each save their own correct return address
    test7:
        la   t3, jal_ret_7a
        jal  t0, jal_func_7         // t0 should = jal_ret_7a
    jal_ret_7a:
        beq  t0, t3, test8
        j    Fail_Jal_7
    jal_func_7:
        jalr zero, t0, 0

    // test8: jal return address is exactly 4 bytes after jal (verify via la comparison)
    test8:
        jal  t0, jal_target_8
    jal_after_8:                    // PC+4 of the jal above
        j    Fail_Jal_8             // if we fall through, t0 was wrong
    jal_target_8:
        la   t1, jal_after_8
        beq  t0, t1, test9
        j    Fail_Jal_8

    // test9: jal with x0 rd does not corrupt x0 (x0 stays 0)
    test9:
        jal  zero, jal_target_9
        j    Fail_Jal_9
    jal_target_9:
        beq  zero, zero, test10     // x0 still 0 -> beq taken
        j    Fail_Jal_9

    // test10: jal to immediately next instruction (smallest positive offset = 4)
    test10:
        jal  t0, jal_next_10
        j    Fail_Jal_10
    jal_next_10:
        j    pass

    pass:
        j return_jal_test

Fail_Jal_1:
    li   gp, 1401
    j    fail

Fail_Jal_2:
    li   gp, 1402
    j    fail

Fail_Jal_3:
    li   gp, 1403
    j    fail

Fail_Jal_4:
    li   gp, 1404
    j    fail

Fail_Jal_5:
    li   gp, 1405
    j    fail

Fail_Jal_6:
    li   gp, 1406
    j    fail

Fail_Jal_7:
    li   gp, 1407
    j    fail

Fail_Jal_8:
    li   gp, 1408
    j    fail

Fail_Jal_9:
    li   gp, 1409
    j    fail

Fail_Jal_10:
    li   gp, 1410
    j    fail
