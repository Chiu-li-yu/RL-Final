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

    logic out_and_reg;
    logic out_or_reg;
    logic out_xor_reg;
    logic out_nand_reg;
    logic out_nor_reg;
    logic out_xnor_reg;
    logic out_anotb_reg;

    always @(*) begin
        out_and_reg = a && b;
        out_or_reg = a || b;
        out_xor_reg = a ^ b;
        out_nand_reg = !(a && b);
        out_nor_reg = !(a || b);
        out_xnor_reg = !(a ^ b);
        out_anotb_reg = a && !b;
    end

    assign out_and = out_and_reg;
    assign out_or = out_or_reg;
    assign out_xor = out_xor_reg;
    assign out_nand = out_nand_reg;
    assign out_nor = out_nor_reg;
    assign out_xnor = out_xnor_reg;
    assign out_anotb = out_anotb_reg;

endmodule
