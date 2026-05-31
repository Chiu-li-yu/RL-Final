module TopModule (
    input x,
    input y,
    output z
);
    logic z_out;
    always @(*) begin
        // Truth table mapping based on waveform:
        // x y | z
        // 0 0 | 1
        // 1 0 | 0
        // 0 1 | 0
        // 1 1 | 1
        // This is equivalent to XNOR: z = ~(x ^ y)
        z_out = ~(x ^ y);
    end
    assign z = z_out;
endmodule