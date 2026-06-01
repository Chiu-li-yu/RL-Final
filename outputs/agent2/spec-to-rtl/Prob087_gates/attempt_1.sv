module TopModule (
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);
    logic out_and_i, out_or_i, out_xor_i, out_nand_i, out_nor_i, out_xnor_i, out_anotb_i;

    assign out_and = out_and_i;
    assign out_or = out_or_i;
    assign out_xor = out_xor_i;
    assign out_nand = out_nand_i;
    assign out_nor = out_nor_i;
    assign out_xnor = out_xnor_i;
    assign out_anotb = out_anotb_i;

    always @(*) begin
        out_and_i   = a & b;
        out_or_i    = a | b;
        out_xor_i   = a ^ b;
        out_nand_i  = ~(a & b);
        out_nor_i   = ~(a | b);
        out_xnor_i  = ~(a ^ b);
        out_anotb_i = a & (~b);
    end
endmodule