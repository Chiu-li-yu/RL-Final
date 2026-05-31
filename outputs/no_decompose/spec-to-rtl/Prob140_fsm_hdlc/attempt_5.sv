module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    // States representing the number of consecutive ones
    // 0: 0
    // 1: 1
    // 2: 11
    // 3: 111
    // 4: 1111
    // 5: 11111
    // 6: 111111
    // 7: 1111111+
    
    typedef enum logic [3:0] {
        S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, 
        S5 = 4'd5, S6 = 4'd6, S7 = 4'd7
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) state <= S0;
        else state <= next_state;
    end

    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0; // S5 + 0 = 0111110 (discard)
            S6: next_state = in ? S7 : S0; // S6 + 0 = 01111110 (flag)
            S7: next_state = in ? S7 : S0; // S7 + 1 = 01111111+ (err)
            default: next_state = S0;
        endcase
    end

    // Outputs for the NEXT cycle (Moore machine)
    // S5 + 0 -> disc
    // S6 + 0 -> flag
    // S7 + 1 or S7 + 0 -> err
    // Wait, the spec says "Signal ... on the clock cycle after the condition occurs."
    // 1. (0111110) disc:
    //    Condition 0111110 met when current bit is 0 and prev state was S5.
    // 2. (01111110) flag:
    //    Condition 01111110 met when current bit is 0 and prev state was S6.
    // 3. (01111111+) err:
    //    Condition met when current bit is 1 and prev state was S6 or S7.
    
    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            disc <= (state == S5 && !in);
            flag <= (state == S6 && !in);
            err  <= (state == S6 && in) || (state == S7 && in);
        end
    end

endmodule
