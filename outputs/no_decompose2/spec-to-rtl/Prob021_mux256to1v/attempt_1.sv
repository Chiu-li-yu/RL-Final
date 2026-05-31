module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    logic [3:0] out_reg;

    always @(*) begin
        out_reg = in[sel*4 +: 4];
    end

    assign out = out_reg;
endmodule
