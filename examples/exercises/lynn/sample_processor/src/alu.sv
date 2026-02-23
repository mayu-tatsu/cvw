// riscvsingle.sv
// RISC-V single-cycle processor
// David_Harris@hmc.edu 2020

module alu(
        input   logic [31:0]    SrcA, SrcB,
        input   logic [3:0]     ALUControl,     // extended to add more control signals
        input   logic [2:0]     Funct3,
        output  logic [31:0]    ALUResult, IEUAdr
    );

    logic [31:0] CondInvb, Sum, SLT;
    logic Sub, Overflow, Neg, LT;           // removed ALUOp, never used
    logic [2:0] ALUFunct;
    logic LTU;

    assign LTU = (SrcA < SrcB);

    // Add or subtract
    assign CondInvb = Sub ? ~SrcB : SrcB;
    assign Sum = SrcA + CondInvb + {{(31){1'b0}}, Sub};
    assign IEUAdr = Sum; // Send this out to IFU and LSU

    // Set less than based on subtraction result
    assign Overflow = (SrcA[31] ^ SrcB[31]) & (SrcA[31] ^ Sum[31]);
    assign Neg = Sum[31];
    assign LT = Neg ^ Overflow;
    assign SLT = {31'b0, LT};
    // assign ALUFunct = Funct3 & {3{ALUOp}}; // Force ALUFunct to 0 to Add when ALUOp = 0

    assign Sub = ALUControl[3];
    assign ALUFunct = ALUControl[2:0];

    always_comb begin
        case (ALUFunct)
            3'b000: ALUResult = Sum;                // add, sub
            3'b001: ALUResult = SrcA << SrcB[4:0];  // sll, slli
            3'b010: ALUResult = SLT;                // slt, slti
            3'b011: ALUResult = {31'b0, LTU};       // sltu, sltiu
            3'b100: ALUResult = SrcA ^ SrcB;        // xor, xori
            3'b101: ALUResult = Sub                 // sra, srai, srl, srli
                                ? ($signed(SrcA) >>> SrcB[4:0])
                                : SrcA >> SrcB[4:0];
            3'b110: ALUResult = SrcA | SrcB;        // or
            3'b111: ALUResult = SrcA & SrcB;        // and
            default: ALUResult = 'x;
        endcase
    end
endmodule
