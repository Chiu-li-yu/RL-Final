module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    // Moore FSM states:
    // S0: Still processing 0s (no 1 yet)
    // S1: After the first 1 has been processed (flip all subsequent bits)
    
    logic state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            0: next_state = (x == 1) ? 1 : 0;
            1: next_state = 1;
            default: next_state = 0;
        endcase
    end

    // Moore machine output depends only on state and possibly x?
    // Wait, standard serial 2's complement:
    // S0: output x, then if x=1 go to S1
    // S1: output !x, stay in S1
    
    // Actually, to keep it a pure Moore machine:
    // The output should be a function of the state. 
    // Let's refine the states/outputs.
    // If input is 00100 (LSB first), 2's complement is 11100.
    // LSB 0 -> out 0, State 0
    // LSB 0 -> out 0, State 0
    // LSB 1 -> out 1, State 1
    // LSB 0 -> out 1, State 1
    // LSB 0 -> out 1, State 1
    
    // To make it Moore: Output must be a state register.
    // We can use a register to hold the output.
    
    logic z_out;
    assign z = z_out;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            z_out <= 0;
        else begin
            // Logic to calculate output for current state
            if (state == 0)
                z_out <= x;
            else
                z_out <= !x;
        end
    end

endmodule