module TopModule (
    input x,
    input y,
    output logic z
);
    // Analysis of the truth table:
    // x y | z
    // 0 0 | 1
    // 1 0 | 0
    // 0 1 | 0
    // 1 1 | 1
    
    // This matches the logic: z = ~(x ^ y) or z = (x == y)
    
    always @(*) begin
        z = ~(x ^ y);
    end
endmodule
