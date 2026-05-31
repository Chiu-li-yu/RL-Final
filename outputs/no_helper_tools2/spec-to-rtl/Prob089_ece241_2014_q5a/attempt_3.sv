module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    // Serial 2's complementer
    // State 0: LSBs are 0, output is 0.
    // State 1: Found the first 1, output is 1, then invert everything.
    
    logic state;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else if (state == 1'b0)
            state <= x;
        else
            state <= 1'b1;
    end
    
    // Moore Machine: Output depends ONLY on the state.
    // Wait, the specification says "Moore state machine".
    // If it's pure Moore, the output Z cannot depend on X.
    
    // Let's redefine the states to be pure Moore.
    // S0: output 0, seen no 1s
    // S1: output 1, seen first 1
    // S2: output 0, seen 1s, now inverting (0->1, 1->0)
    
    logic [1:0] state_m, next_state;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state_m <= 2'b00;
        else
            state_m <= next_state;
    end
    
    always @(*) begin
        case (state_m)
            2'b00: next_state = x ? 2'b01 : 2'b00; // Found 1
            2'b01: next_state = x ? 2'b10 : 2'b11; // 1->0, 0->1
            2'b10: next_state = x ? 2'b10 : 2'b11; // 1->0
            2'b11: next_state = x ? 2'b10 : 2'b11; // 0->1
            default: next_state = 2'b00;
        endcase
    end
    
    assign z = (state_m == 2'b01) | (state_m == 2'b11);

endmodule
