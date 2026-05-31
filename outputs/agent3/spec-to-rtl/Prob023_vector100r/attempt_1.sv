module TopModule(
    input  [99:0] in,
    output [99:0] out
);

    logic [99:0] out_temp;

    always @(*) begin
        for (int i = 0; i < 100; i = i + 1) begin
            out_temp[i] = in[99 - i];
        end
    end

    assign out = out_temp;

endmodule
