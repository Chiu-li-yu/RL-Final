module TopModule (
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    logic out_and_val;
    logic out_or_val;
    logic out_xor_val;
    logic out_nand_val;
    logic out_nor_val;
    logic out_xnor_val;
    logic out_anotb_val;

    always @(*) begin
        out_and_val   = a & b;
        out_or_val    = a | b;
        out_xor_val   = a ^ b;
        out_nand_val  = ~(a & b);
        out_nor_val   = ~(a | b);
        out_xnor_val  = ~(a ^ b);
        out_anotb_val = a & (~b);
    end

    assign out_and   = out_and_val;
    assign out_or    = out_or_val;
    assign out_xor   = out_xor_val;
    assign out_nand  = out_nand_val;
    assign out_nor   = out_nor_val;
    assign out_xnor  = out_xnor_val;
    assign out_anotb = out_anotb_val;

endmodule
