module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    logic [99:0] out_tmp;
    integer i;

    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            out_tmp[i] = in[99 - i];
        end
    end

    assign out = out_tmp;

endmodule
