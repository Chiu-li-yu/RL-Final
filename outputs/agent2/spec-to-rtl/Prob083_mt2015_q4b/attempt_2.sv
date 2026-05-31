module TopModule (
    input x,
    input y,
    output logic z
);
    // Truth table from waveform:
    // x y | z
    // 0 0 | 1
    // 1 0 | 0
    // 0 1 | 0
    // 1 1 | 1
    
    // This is equivalent to XNOR: z = ~(x ^ y)
    
    always @(*) begin
        z = ~(x ^ y);
    end
endmodule
