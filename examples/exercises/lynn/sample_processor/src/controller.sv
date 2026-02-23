// riscvsingle.sv
// RISC-V single-cycle processor
// David_Harris@hmc.edu 2020

`include "parameters.svh"

module controller(
        input   logic [6:0]   Op,
        input   logic         Eq,
        input   logic [2:0]   Funct3,
        input   logic         Funct7b5,
        output  logic         ALUResultSrc,
        output  logic         ResultSrc,
        output  logic         PCSrc,
        output  logic         RegWrite,
        output  logic [1:0]   ALUSrc,
        output  logic [3:0]   ALUControl,
        output  logic [2:0]   ImmSrc,       // extended to add more control signals
        output  logic         MemEn,
        input   logic         Lt, LtU,      // new branch condition signals, from CMP
        output  logic         JalR, MemWrite
    `ifdef DEBUG
        , input   logic [31:0]  insn_debug
    `endif
    );

    logic Branch, Jump;
    logic Sub, ALUOp;
    logic [12:0] controls;              // extended
    logic BranchTaken;

    // Main decoder
    always_comb
        case(Op)
            // RegWrite_ImmSrc_ALUSrc_ALUOp_ALUResultSrc_MemWrite_ResultSrc_Branch_Jump_Load
            // NEW: RegWrite_ImmSrc[2:0]_ALUSrc[1:0]_ALUOp_ALUResultSrc_MemWrite_ResultSrc_Branch_Jump_MemEn
            7'b0000011: controls = 13'b1_000_01_0_0_0_1_0_0_1; // loads (lw/lh/lb)
            7'b0100011: controls = 13'b0_001_01_0_0_1_0_0_0_1; // stores (sw/sh/sb)
            7'b0110011: controls = 13'b1_xxx_00_1_0_0_0_0_0_0; // R-type
            7'b0010011: controls = 13'b1_000_10_1_0_0_0_0_0_0; // I-type ALU (ALUSrc=imm only)
            7'b1100011: controls = 13'b0_010_11_0_0_0_0_1_0_0; // branches
            7'b1101111: controls = 13'b1_011_11_0_1_0_0_0_1_0; // jal
            7'b1100111: controls = 13'b1_000_10_0_1_0_0_0_1_0; // jalr
            7'b0110111: controls = 13'b1_100_11_0_0_0_0_0_0_0; // lui  (SrcA=0, SrcB=Imm, ADD)
            7'b0010111: controls = 13'b1_100_01_0_0_0_0_0_0_0; // auipc (SrcA=PC, SrcB=Imm)
            default: begin
                `ifdef DEBUG
                    controls = 13'bx_xxx_xx_x_x_x_x_x_x_x; // non-implemented instruction
                    if ((insn_debug !== 'x)) begin
                        $display("Instruction not implemented: %h", insn_debug);
                        $finish(-1);
                    end
                `else
                    controls = 13'b0; // non-implemented instruction
                `endif
            end
        endcase

    assign {RegWrite, ImmSrc, ALUSrc, ALUOp, ALUResultSrc, MemWrite,
        ResultSrc, Branch, Jump, MemEn} = controls;

    // ALU Control Logic
    //      if ALUOp=0 (loads/stores/branches): force ADD (3'b000)
    //      if ALUOp=1: use Funct3 directly to select operation
    assign Sub = ALUOp & (Funct7b5 & (Funct3 == 3'b000 | Funct3 == 3'b101));
    assign ALUControl = {Sub, ALUOp ? Funct3 : 3'b000};

    // PCSrc logic
    always_comb begin
        case (Funct3)
            3'b000: BranchTaken = Eq;           // beq
            3'b001: BranchTaken = ~Eq;          // bne
            3'b100: BranchTaken = Lt;           // blt
            3'b101: BranchTaken = ~Lt;          // bge
            3'b110: BranchTaken = LtU;          // bltu
            3'b111: BranchTaken = ~LtU;         // bgeu
            default: BranchTaken = 1'bx;        // undefined
        endcase
    end
    assign PCSrc = (Branch & BranchTaken) | Jump;

    // MemWrite logic (WriteByteEn) --> moved to datapath

    assign JalR = (Op == 7'b1100111);
endmodule
