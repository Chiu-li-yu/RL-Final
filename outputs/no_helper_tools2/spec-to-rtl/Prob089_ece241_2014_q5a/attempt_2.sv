module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    // State 0: output 0, transition 0->0, 1->1 (State 1)
    // State 1: output !x, transition 1->1
    
    // Actually, serial 2's complementer logic:
    // When bit is 0, output is 0. 
    // Once first 1 is encountered, output that 1, then invert all subsequent bits.
    
    // Let's re-evaluate:
    // Input:  ... 0 1 0 0 (4)
    // Output: ... 1 1 0 0 (-4)
    // Bits:   L S B ... M S B
    
    // If bit is 0, complement is 0. 
    // If bit is 1, complement is 1, then invert remaining.
    
    logic state; // 0: haven't seen '1', 1: seen '1'
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else if (state == 1'b0)
            state <= x;
        else
            state <= 1'b1;
    end
    
    assign z = (state == 1'b0) ? x : !x;

endmodule
