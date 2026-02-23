module mux3 #(parameter WIDTH) (
        input   logic [WIDTH-1:0]   A,
        input   logic [WIDTH-1:0]   B,
        input   logic [WIDTH-1:0]   C,
        input   logic [1:0]         select,

        output  logic [WIDTH-1:0]   result
    );

    assign result = select == 2'b00 ? A : select == 2'b01 ? B : C;

endmodule
