// riscvsingle.sv
// RISC-V single-cycle processor
// David_Harris@hmc.edu 2020 kacassidy@hmc.edu 2025

module ifu(
        input   logic           clk, reset,
        input   logic           PCSrc, JalR,
        input   logic [31:0]    IEUAdr,
        output  logic [31:0]    PC, PCPlus4
    );

    logic [31:0] PCNext;
    // next PC logic
    logic [31:0] entry_addr;
    logic [31:0] JumpTarget;

    initial begin
        // default
        entry_addr = '0;

        // override if provided
        void'($value$plusargs("ENTRY_ADDR=%h", entry_addr));

        $display("[TB] ENTRY_ADDR = 0x%h", entry_addr);
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset)  PC <= entry_addr;
        else        PC <= PCNext;
    end

    adder pcadd4(PC, 32'd4, PCPlus4);
    // mux2 #(32) pcmux(PCPlus4, IEUAdr, PCSrc, PCNext);
    assign JumpTarget = {IEUAdr[31:1], JalR ? 1'b0 : IEUAdr[0]};
    mux2 #(32) pcmux(PCPlus4, JumpTarget, PCSrc, PCNext);
endmodule
