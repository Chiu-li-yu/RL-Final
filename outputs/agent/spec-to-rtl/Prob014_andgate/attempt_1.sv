module TopModule (
    input  a,
    input  b,
    output out
);
    logic out_reg;
    assign out = out_reg;

    always @(*) begin
        out_reg = a & b;
    end
endmodule
