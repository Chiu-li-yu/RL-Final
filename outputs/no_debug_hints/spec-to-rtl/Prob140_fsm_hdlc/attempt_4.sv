module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    parameter [3:0] S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6_DISC = 6, S6_FLAG = 7, S7_ERR = 8;
    logic [3:0] current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6_FLAG : S6_DISC;
            S6_DISC: next_state = in ? S1 : S0;
            S6_FLAG: next_state = in ? S7_ERR : S0;
            S7_ERR: next_state = in ? S7_ERR : S0;
            default: next_state = S0;
        endcase
    end

    // Moore FSM: Output depends on state. 
    // The spec says: "The output signals should be asserted for a complete cycle beginning on the clock cycle AFTER the condition occurs."
    // My current implementation: State = S6_FLAG -> flag=1 in that cycle. 
    // If the transition to S6_FLAG happens at time T, flag is 1 at time T.
    // This is correct Moore output. Let's re-verify the transition logic.
    // Spec: 
    // 0111110: S5 -> S6_DISC (when in=0)
    // 01111110: S5 -> S6_FLAG (when in=1)
    // 01111111: S6_FLAG -> S7_ERR (when in=1)
    
    // Maybe S6_DISC and S6_FLAG should go to S0 or S1?
    // 0111110: After disc, last bit is 0, so next state should be S0. Correct.
    // 01111110: After flag, last bit is 0, so next state should be S0. Correct.
    
    assign disc = (current_state == S6_DISC);
    assign flag = (current_state == S6_FLAG);
    assign err  = (current_state == S7_ERR);

endmodule
