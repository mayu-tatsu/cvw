// C Runtime entry point
// James Kaden Cassidy
// kacassidy@hmc.edu
// 1/21/2026

.extern add_test
.extern or_test
.extern and_test
.extern sub_test

.extern addi_test
.extern ori_test
.extern andi_test
.extern subi_test
.extern xor_test
.extern xori_test
.extern beq_test
.extern lw_test
.extern sw_test
.extern slt_i_test
.extern jal_test
.extern sll_test
.extern srl_test
.extern sra_test
.extern sltu_test
.extern lb_test
.extern lh_test
.extern sb_test
.extern sh_test
.extern bne_test
.extern blt_test
.extern bge_test
.extern jalr_test
.extern lui_test
.extern auipc_test

    .section .text.init
    .globl main
    .globl return_add_test
    .globl return_or_test
    .globl return_and_test
    .globl return_sub_test
    .type  main, @function

    .globl return_addi_test
    .globl return_ori_test
    .globl return_andi_test
    .globl return_subi_test
    .globl return_xor_test
    .globl return_xori_test
    .globl return_beq_test
    .globl return_lw_test
    .globl return_sw_test
    .globl return_slt_i_test
    .globl return_jal_test
    .globl return_sll_test
    .globl return_srl_test
    .globl return_sra_test
    .globl return_sltu_test
    .globl return_lb_test
    .globl return_lh_test
    .globl return_sb_test
    .globl return_sh_test
    .globl return_bne_test
    .globl return_blt_test
    .globl return_bge_test
    .globl return_jalr_test
    .globl return_lui_test
    .globl return_auipc_test

main:
    j add_test              // 100s

return_add_test:
    j or_test               // 200s

return_or_test:
    j and_test              // 300s

return_and_test:
    j sub_test              // 400s

return_sub_test:
    j addi_test             // 500s

return_addi_test:
    j ori_test              // 600s

return_ori_test:
    j andi_test             // 700s

return_andi_test:
    j subi_test             // 800s

return_subi_test:
    j xor_test              // 900s

return_xor_test:
    j xori_test             // 1000s

return_xori_test:
    j beq_test              // 1100s

return_beq_test:
    j lw_test               // 1200s

return_lw_test:
    j sw_test               // 1300s

return_sw_test:
    j jal_test              // 1400s

return_jal_test:
    j sll_test              // 1500s

return_sll_test:
    j srl_test              // 1600s

return_srl_test:
    j sra_test              // 1700s

return_sra_test:
    j sltu_test             // 1800s

return_sltu_test:
    j lb_test               // 1900s

return_lb_test:
    j lh_test               // 2000s

return_lh_test:
    j sb_test               // 2100s

return_sb_test:
    j sh_test               // 2200s

return_sh_test:
    j bne_test              // 2300s

return_bne_test:
    j blt_test              // 2400s

return_blt_test:
    j bge_test              // 2500s

return_bge_test:
    j jalr_test             // 2600s

return_jalr_test:
    j lui_test              // 2700s

return_lui_test:
    j auipc_test            // 2800s

return_auipc_test:
    j pass

return_slt_i_test:          // slt_i shares 1500s range in original; kept for linkage
    j pass
