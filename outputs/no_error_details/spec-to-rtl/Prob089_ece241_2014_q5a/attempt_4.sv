module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    // Simple state machine:
    // State 0: LSBs encountered so far are all 0s.
    // State 1: The first 1 has been encountered.

    logic state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Mealy machine: z = f(state, x)
    // Most serial 2's complementers are naturally Mealy.
    // If the prompt insists on Moore, the output must be registered.
    
    // Let's try registering the output.
    logic z_reg;
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            z_reg <= 1'b0;
        else
            z_reg <= (state == 1'b0) ? x : ~x;
    end
    
    // BUT the output needs to be available on the same cycle as x?
    // "The input (x) is a series of bits (one per clock cycle)... output (z) is..."
    // Usually implies combinational output.
    
    // Let's try the most basic Mealy implementation again, 
    // but verify the reset and logic.
    
    always @(*) begin
        if (state == 1'b0)
            next_state = x ? 1'b1 : 1'b0;
        else
            next_state = 1'b1;
    end

    assign z = (state == 1'b0) ? x : ~x;

endmodule
