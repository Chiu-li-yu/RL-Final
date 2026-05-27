module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    logic [99:0] out_tmp;

    always @(*) begin
        if (sel) begin
            out_tmp = b;
        end else begin
            out_tmp = a;
        end
    end

    assign out = out_tmp;

endmodule