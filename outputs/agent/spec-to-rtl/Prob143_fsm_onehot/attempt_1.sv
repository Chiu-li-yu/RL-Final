module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    logic [9:0] next_state_comb;
    logic out1_comb;
    logic out2_comb;

    assign next_state = next_state_comb;
    assign out1 = out1_comb;
    assign out2 = out2_comb;

    always @(*) begin
        next_state_comb = 10'b0;
        out1_comb = 0;
        out2_comb = 0;

        // Transition Logic
        // S0: --0--> S0; --1--> S1
        if (state[0]) begin
            if (in) next_state_comb[1] = 1;
            else    next_state_comb[0] = 1;
        end
        // S1: --0--> S0; --1--> S2
        if (state[1]) begin
            if (in) next_state_comb[2] = 1;
            else    next_state_comb[0] = 1;
        end
        // S2: --0--> S0; --1--> S3
        if (state[2]) begin
            if (in) next_state_comb[3] = 1;
            else    next_state_comb[0] = 1;
        end
        // S3: --0--> S0; --1--> S4
        if (state[3]) begin
            if (in) next_state_comb[4] = 1;
            else    next_state_comb[0] = 1;
        end
        // S4: --0--> S0; --1--> S5
        if (state[4]) begin
            if (in) next_state_comb[5] = 1;
            else    next_state_comb[0] = 1;
        end
        // S5: --0--> S8; --1--> S6
        if (state[5]) begin
            if (in) next_state_comb[6] = 1;
            else    next_state_comb[8] = 1;
        end
        // S6: --0--> S9; --1--> S7
        if (state[6]) begin
            if (in) next_state_comb[7] = 1;
            else    next_state_comb[9] = 1;
        end
        // S7: (0, 1) --0--> S0; --1--> S7
        if (state[7]) begin
            out2_comb = 1;
            if (in) next_state_comb[7] = 1;
            else    next_state_comb[0] = 1;
        end
        // S8: (1, 0) --0--> S0; --1--> S1
        if (state[8]) begin
            out1_comb = 1;
            if (in) next_state_comb[1] = 1;
            else    next_state_comb[0] = 1;
        end
        // S9: (1, 1) --0--> S0; --1--> S1
        if (state[9]) begin
            out1_comb = 1;
            out2_comb = 1;
            if (in) next_state_comb[1] = 1;
            else    next_state_comb[0] = 1;
        end
    end

endmodule
