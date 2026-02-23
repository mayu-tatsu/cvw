.extern return_jalr_test
.extern fail

    .section .text.init
    .globl jalr_test
    .type  jalr_test, @function

jalr_test:
    // test1: jalr basic - jump to address in register, skips j Fail after
    test1:
        la   t1, jalr_target_1
        jalr t0, t1, 0
        j    Fail_Jalr_1
    jalr_target_1:
        j    test2

    // test2: jalr saves PC+4 in rd
    // jalr_ret_2 must be immediately after the jalr instruction (no j in between)
    test2:
        la   t1, jalr_ret_2         // t1 = expected return address
        la   t2, jalr_target_2
        jalr t0, t2, 0              // t0 = PC+4 = address of jalr_ret_2
    jalr_ret_2:                     // <- must be exactly PC+4 of jalr above
        beq  t0, t1, test3
        j    Fail_Jalr_2
    jalr_target_2:
        jalr zero, t0, 0            // return to jalr_ret_2

    // test3: jalr with nonzero positive offset (base + 8)
    test3:
        la   t1, jalr_base_3
        jalr t0, t1, 8              // jump to jalr_base_3 + 8
        j    Fail_Jalr_3
        j    Fail_Jalr_3            // base - 4 (padding so offsets line up)
    jalr_base_3:
        j    Fail_Jalr_3            // base + 0
        j    Fail_Jalr_3            // base + 4
        j    test4                  // base + 8 <- should land here

    // test4: jalr with x0 as rd discards return address
    test4:
        la   t1, jalr_target_4
        jalr zero, t1, 0
        j    Fail_Jalr_4
    jalr_target_4:
        j    test5

    // test5: jalr clears LSB of computed address ((rs1+imm) & ~1)
    test5:
        la   t1, jalr_target_5
        ori  t1, t1, 1              // set LSB to force alignment clear
        jalr t0, t1, 0              // should jump to jalr_target_5 (LSB cleared)
        j    Fail_Jalr_5
    jalr_target_5:
        j    test6

    // test6: jalr does not modify rs1
    test6:
        la   t1, jalr_target_6
        mv   t3, t1                 // save copy of rs1
        jalr t0, t1, 0
    jalr_ret_6:
        beq  t1, t3, test7
        j    Fail_Jalr_6
    jalr_target_6:
        jalr zero, t0, 0

    // test7: jalr used as return via ra (canonical ret pattern)
    test7:
        la   t1, jalr_target_7
        jalr ra, t1, 0              // ra = PC+4 = jalr_ret_7
    jalr_ret_7:
        j    test8
    jalr_target_7:
        jalr zero, ra, 0            // return to jalr_ret_7

    // test8: jalr with negative offset
    test8:
        la   t1, jalr_base_8
        jalr t0, t1, -4             // jump to jalr_base_8 - 4 = jalr_pre_8
        j    Fail_Jalr_8
    jalr_pre_8:                     // jalr_base_8 - 4 (must be 4 bytes before base)
        j    test9
    jalr_base_8:
        j    Fail_Jalr_8            // should NOT land here

    // test9: rd is nonzero after jalr (was actually written)
    test9:
        la   t1, jalr_target_9
        jalr t0, t1, 0
    jalr_ret_9:
        beq  t0, zero, Fail_Jalr_9
        j    test10
    jalr_target_9:
        jalr zero, t0, 0

    // test10: chained jalr calls - each returns correctly
    test10:
        la   t1, jalr_func_10a
        la   ra, jalr_ret_10
        jalr zero, t1, 0
        j    Fail_Jalr_10
    jalr_ret_10:
        j    pass
    jalr_func_10a:
        la   t1, jalr_func_10b
        jalr t0, t1, 0              // t0 = return address inside func_10a
        jalr zero, ra, 0            // return to original caller (jalr_ret_10)
    jalr_func_10b:
        jalr zero, t0, 0            // return into jalr_func_10a

    pass:
        j return_jalr_test

Fail_Jalr_1:
    li   gp, 2601
    j    fail

Fail_Jalr_2:
    li   gp, 2602
    j    fail

Fail_Jalr_3:
    li   gp, 2603
    j    fail

Fail_Jalr_4:
    li   gp, 2604
    j    fail

Fail_Jalr_5:
    li   gp, 2605
    j    fail

Fail_Jalr_6:
    li   gp, 2606
    j    fail

Fail_Jalr_7:
    li   gp, 2607
    j    fail

Fail_Jalr_8:
    li   gp, 2608
    j    fail

Fail_Jalr_9:
    li   gp, 2609
    j    fail

Fail_Jalr_10:
    li   gp, 2610
    j    fail
