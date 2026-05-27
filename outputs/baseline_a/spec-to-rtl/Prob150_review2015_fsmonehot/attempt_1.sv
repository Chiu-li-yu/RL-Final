module TopModule (
    input logic d,
    input logic done_counting,
    input logic ack,
    input logic [9:0] state,
    output logic B3_next,
    output logic S_next,
    output logic S1_next,
    output logic Count_next,
    output logic Wait_next,
    output logic done,
    output logic counting,
    output logic shift_ena
);

    // One-hot encoding mapping:
    // S    = state[0]
    // S1   = state[1]
    // S11  = state[2]
    // S110 = state[3]
    // B0   = state[4]
    // B1   = state[5]
    // B2   = state[6]
    // B3   = state[7]
    // Count= state[8]
    // Wait = state[9]

    logic next_S, next_S1, next_S11, next_S110, next_B0, next_B1, next_B2, next_B3, next_Count, next_Wait;

    always @(*) begin
        next_S    = (state[0] && !d) || (state[1] && !d) || (state[3] && !d) || (state[9] && ack);
        next_S1   = (state[0] && d) || (state[1] && d);
        next_S11  = (state[1] && d) || (state[2] && d); // Wait, S1 to S11: wait, S1 -> S11? Spec says S1-d=1->S11
        // Re-evaluating transitions based on spec:
        // S --0--> S, --1--> S1
        // S1 --0--> S, --1--> S11
        // S11 --0--> S110, --1--> S11
        // S110 --0--> S, --1--> B0
        
        next_S    = (state[0] && !d) || (state[1] && !d) || (state[3] && !d) || (state[9] && ack);
        next_S1   = (state[0] && d);
        next_S11  = (state[1] && d) || (state[2] && d);
        next_S110 = (state[2] && !d);
        next_B0   = (state[3] && d);
        next_B1   = state[4];
        next_B2   = state[5];
        next_B3   = state[6];
        next_Count = (state[7]) || (state[8] && !done_counting);
        next_Wait = (state[8] && done_counting) || (state[9] && !ack);

        // Outputs
        shift_ena = state[4] || state[5] || state[6] || state[7];
        counting  = state[8];
        done      = state[9];

        // Required ports
        B3_next    = next_B3;
        S_next     = next_S;
        S1_next    = next_S1;
        Count_next = next_Count;
        Wait_next  = next_Wait;
    end

endmodule
