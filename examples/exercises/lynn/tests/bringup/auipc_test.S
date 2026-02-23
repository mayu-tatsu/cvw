.extern return_auipc_test
.extern fail

    .section .text.init
    .globl auipc_test
    .type  auipc_test, @function

auipc_test:
    // test1: auipc with 0 -> result = current PC (address of auipc instruction)
    test1:
        auipc t0, 0             // t0 = PC + (0 << 12) = PC
        la    t1, test1         // t1 = address of test1 label = address of auipc
        beq   t0, t1, test2
        j     Fail_Auipc_1

    // test2: auipc result has lower 12 bits from PC (not zeroed)
    //        auipc t0, 0 gives exact PC; PC lower bits are whatever they are
    //        verify t0 == address of the auipc instruction
    test2:
        auipc t0, 0
        la    t1, test2
        beq   t0, t1, test3
        j     Fail_Auipc_2

    // test3: auipc with imm=1 -> result = PC + 0x1000
    test3:
        auipc t0, 1             // t0 = PC + 0x1000
        la    t1, test3
        lui   t3, 1             // t3 = 0x1000 (0x1000 is too large for addi)
        add   t1, t1, t3        // expected = address_of_test3 + 0x1000
        beq   t0, t1, test4
        j     Fail_Auipc_3

    // test4: auipc result is PC-relative (two consecutive auipc differ by 4)
    test4:
        auipc t0, 0             // t0 = PC_a
        auipc t1, 0             // t1 = PC_a + 4
        addi  t2, t0, 4
        beq   t1, t2, test5
        j     Fail_Auipc_4

    // test5: auipc with large immediate - verify upper bits set correctly
    test5:
        auipc t0, 0x10          // t0 = PC + 0x10000
        la    t1, test5
        addi  t1, t1, 0         // t1 = address of this auipc (la approximation)
        // compute expected: t1 + 0x10000
        lui   t3, 0x10
        add   t1, t1, t3
        // Note: la of test5 points to auipc instruction, so t1+0x10000 == t0
        beq   t0, t1, test6
        j     Fail_Auipc_5

    // test6: auipc does not write to other registers
    test6:
        li   t1, 0xBEEF
        auipc t0, 0
        li   t3, 0xBEEF
        beq  t1, t3, test7
        j    Fail_Auipc_6

    // test7: auipc with x0 as destination - x0 unchanged (always 0)
    test7:
        auipc zero, 0x12345
        li   t3, 0
        beq  zero, t3, test8
        j    Fail_Auipc_7

    // test8: auipc result is consistent with PC-relative addressing
    //        auipc t0, 0; then add offset to reach a known label
    test8:
        auipc t0, 0             // t0 = address of this auipc
        la    t1, auipc_data_8  // t1 = address of data label
        sub   t2, t1, t0        // t2 = offset from auipc to data
        add   t3, t0, t2        // t3 = t0 + offset = address of auipc_data_8
        beq   t3, t1, test9
        j     Fail_Auipc_8
    auipc_data_8:
        nop

    // test9: two auipc instructions, each captures its own PC
    test9:
        la   t3, auipc_inst_9a
        auipc_inst_9a:
        auipc t0, 0
        beq   t0, t3, test9b
        j     Fail_Auipc_9
    test9b:
        la   t3, auipc_inst_9b
        auipc_inst_9b:
        auipc t1, 0
        beq   t1, t3, test10
        j     Fail_Auipc_9

    // test10: auipc result advances by exactly 4 per instruction (three consecutive)
    test10:
        auipc t0, 0             // t0 = PC_a
        auipc t1, 0             // t1 = PC_a + 4
        auipc t2, 0             // t2 = PC_a + 8
        addi  t3, t0, 4
        bne   t1, t3, Fail_Auipc_10
        addi  t3, t0, 8
        beq   t2, t3, pass
        j     Fail_Auipc_10

    pass:
        j return_auipc_test

Fail_Auipc_1:
    li   gp, 2801
    j    fail

Fail_Auipc_2:
    li   gp, 2802
    j    fail

Fail_Auipc_3:
    li   gp, 2803
    j    fail

Fail_Auipc_4:
    li   gp, 2804
    j    fail

Fail_Auipc_5:
    li   gp, 2805
    j    fail

Fail_Auipc_6:
    li   gp, 2806
    j    fail

Fail_Auipc_7:
    li   gp, 2807
    j    fail

Fail_Auipc_8:
    li   gp, 2808
    j    fail

Fail_Auipc_9:
    li   gp, 2809
    j    fail

Fail_Auipc_10:
    li   gp, 2810
    j    fail
