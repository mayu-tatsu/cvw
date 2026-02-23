.extern return_beq_test
.extern fail

    .section .text.init
    .globl beq_test
    .type  beq_test, @function

beq_test:

    # Test 1: Basic taken
    test1:
        li   t0, 42
        li   t1, 42
        beq  t0, t1, test2
        j    Fail_Beq_1

    # Test 2: Basic not taken
    test2:
        li   t0, 10
        li   t1, 20
        beq  t0, t1, Fail_Beq_2
        j    test3

    # Test 3: Both zero
    test3:
        li   t0, 0
        li   t1, 0
        beq  t0, t1, test4
        j    Fail_Beq_3

    # Test 4: Compare register with x0 directly
    test4:
        li   t0, 0
        beq  t0, x0, test5
        j    Fail_Beq_4

    # Test 5: Same register compared to itself (always taken)
    test5:
        li   t0, 123
        beq  t0, t0, test6
        j    Fail_Beq_5

    # Test 6: Negative equal
    test6:
        li   t0, -5
        li   t1, -5
        beq  t0, t1, test7
        j    Fail_Beq_6

    # Test 7: Positive vs negative same magnitude (not equal)
    test7:
        li   t0, 10
        li   t1, -10
        beq  t0, t1, Fail_Beq_7
        j    test8

    # Test 8: Backward branch (loop) — counts 0 to 3
    test8:
        li   t0, 0
        li   t1, 3
    test8_loop:
        addi t0, t0, 1
        beq  t0, t1, test9      # exit when t0 == 3
        j    test8_loop
        j    Fail_Beq_8         # unreachable if beq works

    # Test 9: Branch doesn't modify registers
    test9:
        li   t0, 100
        li   t1, 100
        beq  t0, t1, test10
        j    Fail_Beq_9

    # Test 10: Max 12-bit positive values (equal)
    test10:
        li   t0, 2047
        li   t1, 2047
        beq  t0, t1, test11
        j    Fail_Beq_10

    # Test 11: Max 12-bit positive values (not equal, off by one)
    test11:
        li   t0, 2047
        li   t1, 2046
        beq  t0, t1, Fail_Beq_11
        j    pass

    pass:
        j    return_beq_test

Fail_Beq_1:
    li   gp, 1101
    j    fail

Fail_Beq_2:
    li   gp, 1102
    j    fail

Fail_Beq_3:
    li   gp, 1103
    j    fail

Fail_Beq_4:
    li   gp, 1104
    j    fail

Fail_Beq_5:
    li   gp, 1105
    j    fail

Fail_Beq_6:
    li   gp, 1106
    j    fail

Fail_Beq_7:
    li   gp, 1107
    j    fail

Fail_Beq_8:
    li   gp, 1108
    j    fail

Fail_Beq_9:
    li   gp, 1109
    j    fail

Fail_Beq_10:
    li   gp, 1110
    j    fail

Fail_Beq_11:
    li   gp, 1111
    j    fail
