module TopModule (
    input in,
    input [9:0] state,
    output logic [9:0] next_state,
    output logic out1,
    output logic out2
);

    always @(*) begin
        // Output logic
        out1 = state[8] | state[9];
        out2 = state[7] | state[9];

        // Next state logic
        // S0 (0, 0) --0--> S0, --1--> S1
        // S1 (0, 0) --0--> S0, --1--> S2
        // S2 (0, 0) --0--> S0, --1--> S3
        // S3 (0, 0) --0--> S0, --1--> S4
        // S4 (0, 0) --0--> S0, --1--> S5
        // S5 (0, 0) --0--> S8, --1--> S6
        // S6 (0, 0) --0--> S9, --1--> S7
        // S7 (0, 1) --0--> S0, --1--> S7
        // S8 (1, 0) --0--> S0, --1--> S1
        // S9 (1, 1) --0--> S0, --1--> S1

        next_state[0] = (state[0] & !in) | (state[1] & !in) | (state[2] & !in) | 
                        (state[3] & !in) | (state[4] & !in) | (state[7] & !in) | 
                        (state[8] & !in) | (state[9] & !in);
                        
        next_state[1] = (state[0] & in) | (state[8] & in) | (state[9] & in);
        next_state[2] = (state[1] & in);
        next_state[3] = (state[2] & in);
        next_state[4] = (state[3] & in);
        next_state[5] = (state[4] & in);
        next_state[6] = (state[5] & in);
        next_state[7] = (state[6] & in) | (state[7] & in);
        next_state[8] = (state[5] & !in);
        next_state[9] = (state[6] & !in);
    end

endmodule
