module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    // States:
    // S0: 0 consecutive 1s (initial/reset state)
    // S1: 1 consecutive 1
    // S2: 2 consecutive 1s
    // S3: 3 consecutive 1s
    // S4: 4 consecutive 1s
    // S5: 5 consecutive 1s
    // S6: 6 consecutive 1s
    // S7: 7+ consecutive 1s (error state)
    
    typedef enum logic [3:0] {
        S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, 
        S4 = 4'd4, S5 = 4'd5, S6 = 4'd6, S7 = 4'd7
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = S0;
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0; // 5 consecutive 1s -> 6th is 1 or 0
            S6: next_state = in ? S7 : S0; // 6 consecutive 1s -> 7th is 1 or 0
            S7: next_state = in ? S7 : S0; // 7+ consecutive 1s (stays in S7 until 0)
            default: next_state = S0;
        endcase
    end

    always_comb begin
        disc = (state == S5 && !in); // Case: 011111 then 0. Actually, the spec says "discarding zero after 5 ones".
        // Wait, the spec says:
        // (1) 0111110: signal disc. (5 ones, then a 0).
        // (2) 01111110: signal flag. (6 ones, then a 0).
        // (3) 01111111...: signal err. (7+ ones).
        
        // Let's refine the logic based on the state reached after input:
        // S5 is "5 ones seen". If input is 0, we transition to S0, and "disc" should be high.
        // S6 is "6 ones seen". If input is 0, we transition to S0, and "flag" should be high.
        // S7 is "7+ ones seen". If we are in S7, we signal err.
    end
    
    // Correction: Outputs are for the cycle AFTER the condition occurs.
    // So the output signals depend on the state transitions.
    
    logic next_disc, next_flag, next_err;
    
    always_comb begin
        next_disc = (state == S5 && !in);
        next_flag = (state == S6 && !in);
        next_err  = (state == S7 || (state == S6 && in));
    end
    
    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= next_disc;
            flag <= next_flag;
            err <= next_err;
        end
    end

endmodule
