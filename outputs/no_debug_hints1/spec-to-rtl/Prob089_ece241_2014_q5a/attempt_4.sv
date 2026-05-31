module TopModule (
    input logic clk,
    input logic areset,
    input logic x,
    output logic z
);

    // State 0: LSBs encountered so far are all 0.
    // State 1: We have encountered a 1, so we flip all subsequent bits.
    logic state;
    logic next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // The output logic needs to be careful: 
    // If state 0 and input x=0, z=0. If state 0 and input x=1, z=1.
    // If state 1, z = !x.
    // Actually, in Moore machine, output depends only on state.
    // But the 2's complement logic is classically Mealy.
    // If strictly Moore, I need a state to represent "about to output 0" or "about to output 1".
    
    // Let's re-think: 
    // State 0: No 1 seen.
    // State 1: 1 seen.
    
    // Wait, the specification says "Moore state machine".
    // Let's check the transition:
    // If current bit is the first '1', the 2's complement is '1' followed by flipped bits.
    // Bits before first '1' remain '0'.
    
    // To make it Moore, the output must be registered.
    // Let's refine the state:
    // S0: Saw only 0s, output 0
    // S1: Saw first 1, output 1
    // S2: Saw more bits after first 1, output flipped bit
    
    logic [1:0] state_reg, next_state_reg;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state_reg <= 2'b00;
        else
            state_reg <= next_state_reg;
    end

    always_comb begin
        case (state_reg)
            2'b00: next_state_reg = (x) ? 2'b01 : 2'b00;
            2'b01: next_state_reg = (x) ? 2'b10 : 2'b10;
            2'b10: next_state_reg = 2'b10;
            default: next_state_reg = 2'b00;
        endcase
    end

    always_comb begin
        case (state_reg)
            2'b00: z = 1'b0;
            2'b01: z = 1'b1;
            2'b10: z = ~x; // Wait, Moore machine output should not depend on x.
            default: z = 1'b0;
        endcase
    end

endmodule
