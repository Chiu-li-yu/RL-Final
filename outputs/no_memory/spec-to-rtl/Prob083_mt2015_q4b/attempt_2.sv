module TopModule (
    input x,
    input y,
    output z
);
    // Analysis:
    // x y | z
    // 0 0 | 1
    // 1 0 | 0
    // 0 1 | 0
    // 1 1 | 1
    // This is XNOR logic: z = ~(x ^ y)
    
    assign z = ~(x ^ y);

endmodule