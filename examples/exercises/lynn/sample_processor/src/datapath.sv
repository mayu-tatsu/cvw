// riscvsingle.sv
// RISC-V single-cycle processor
// David_Harris@hmc.edu 2020

module datapath(
        input   logic           clk, reset,
        input   logic [2:0]     Funct3,
        input   logic           ALUResultSrc, ResultSrc,
        input   logic [1:0]     ALUSrc,
        input   logic           RegWrite,
        input   logic [2:0]     ImmSrc,         // extended
        input   logic [3:0]     ALUControl,     // extended
        output  logic           Eq,
        input   logic [31:0]    PC, PCPlus4,
        input   logic [31:0]    Instr,
        output  logic [31:0]    IEUAdr, WriteData,
        input   logic [31:0]    ReadData,
        output  logic           Lt, LtU,
        input   logic           MemWrite,       // required for WriteByteEn
        output  logic [3:0]    WriteByteEn      // added for byte enables, moved here from controller
    );

    logic [31:0] ImmExt;
    logic [31:0] R1, R2, SrcA, SrcB;
    logic [31:0] ALUResult, IEUResult, Result;

    // register file logic
    regfile rf(.clk, .WE3(RegWrite), .A1(Instr[19:15]), .A2(Instr[24:20]),
        .A3(Instr[11:7]), .WD3(Result), .RD1(R1), .RD2(R2));

    extend ext(.Instr(Instr[31:7]), .ImmSrc, .ImmExt);

    // ALU logic
    cmp cmp(.R1, .R2, .Eq, .Lt, .LtU);

    // ALUSrc[1:0]: 00=R1, 01=PC, 10=0 (lui)
    mux3 #(32) srcamux(R1, PC, 32'b0, ALUSrc[1:0], SrcA);
    mux2 #(32) srcbmux(R2, ImmExt, ALUSrc[0] | ALUSrc[1], SrcB);

    alu alu(.SrcA, .SrcB, .ALUControl, .Funct3, .ALUResult, .IEUAdr);

    mux2 #(32) ieuresultmux(ALUResult, PCPlus4, ALUResultSrc, IEUResult);

    // added read data masking for lb, lh, lbu, lhu based on Funct3 and IEUAdr[1:0]
    logic [31:0] ReadDataMasked;
    always_comb
        case (Funct3)
            3'b000: ReadDataMasked = {{24{ReadData[{IEUAdr[1:0], 3'b111}]}},   // bit [offset+7]
                                      ReadData[{IEUAdr[1:0], 3'b0} +: 8]};
            3'b001: ReadDataMasked = {{16{ReadData[{IEUAdr[1], 4'b1111}]}},    // bit [offset+15]
                                      ReadData[{IEUAdr[1], 4'b0} +: 16]};
            3'b100: ReadDataMasked = {24'b0, ReadData[{IEUAdr[1:0], 3'b0} +: 8]};
            3'b101: ReadDataMasked = {16'b0, ReadData[{IEUAdr[1], 4'b0} +: 16]};
           default: ReadDataMasked = ReadData;
        endcase
    mux2 #(32) resultmux(IEUResult, ReadDataMasked, ResultSrc, Result);

    assign WriteData = R2;

    // added logic for byte enables for store instructions, moved from controller to here
    // needed IEUAdr[1:0]
    always_comb
        if (MemWrite)
            case (Funct3[1:0])
                2'b00: WriteByteEn = 4'b0001 << IEUAdr[1:0]; // sb
                2'b01: WriteByteEn = 4'b0011 << {IEUAdr[1], 1'b0}; // sh
                2'b10: WriteByteEn = 4'b1111; // sw
                default: WriteByteEn = 4'b0000;
            endcase
        else WriteByteEn = 4'b0000;

endmodule
