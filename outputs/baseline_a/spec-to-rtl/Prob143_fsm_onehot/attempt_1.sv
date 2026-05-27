module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    logic [9:0] next_state_comb;
    logic out1_comb, out2_comb;

    always @(*) begin
        next_state_comb = 10'b0;
        out1_comb = 0;
        out2_comb = 0;

        // S0: S0 --0--> S0, S0 --1--> S1
        if (state[0]) begin
            if (~in) next_state_comb[0] = 1'b1;
            else next_state_comb[1] = 1'b1;
        end
        // S1: S1 --0--> S0, S1 --1--> S2
        if (state[1]) begin
            if (~in) next_state_comb[0] = 1'b1;
            else next_state_comb[2] = 1'b1;
        end
        // S2: S2 --0--> S0, S2 --1--> S3
        if (state[2]) begin
            if (~in) next_state_comb[0] = 1'b1;
            else next_state_comb[3] = 1'b1;
        end
        // S3: S3 --0--> S0, S3 --1--> S4
        if (state[3]) begin
            if (~in) next_state_comb[0] = 1'b1;
            else next_state_comb[4] = 1'b1;
        end
        // S4: S4 --0--> S0, S4 --1--> S5
        if (state[4]) begin
            if (~in) next_state_comb[0] = 1'b1;
            else next_state_comb[5] = 1'b1;
        end
        // S5: S5 --0--> S8, S5 --1--> S6
        if (state[5]) begin
            if (~in) next_state_comb[8] = 1'b1;
            else next_state_comb[6] = 1'b1;
        end
        // S6: S6 --0--> S9, S6 --1--> S7
        if (state[6]) begin
            if (~in) next_state_comb[9] = 1'b1;
            else next_state_comb[7] = 1'b1;
        end
        // S7: S7 --0--> S0, S7 --1--> S7
        if (state[7]) begin
            if (~in) next_state_comb[0] = 1'b1;
            else next_state_comb[7] = 1'b1;
            out2_comb = 1'b1;
        end
        // S8: S8 --0--> S0, S8 --1--> S1
        if (state[8]) begin
            if (~in) next_state_comb[0] = 1'b1;
            else next_state_comb[1] = 1'b1;
            out1_comb = 1'b1;
        end
        // S9: S9 --0--> S0, S9 --1--> S1
        if (state[9]) begin
            if (~in) next_state_comb[0] = 1'b1;
            else next_state_comb[1] = 1'b1;
            out1_comb = 1'b1;
            out2_comb = 1'b1;
        end
    end

    assign next_state = next_state_comb;
    assign out1 = out1_comb;
    assign out2 = out2_comb;

endmodule
