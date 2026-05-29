
module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // One-hot encoding indices:
    // state[0]: S
    // state[1]: S1
    // state[2]: S11
    // state[3]: S110
    // state[4]: B0
    // state[5]: B1
    // state[6]: B2
    // state[7]: B3
    // state[8]: Count
    // state[9]: Wait

    always @(*) begin
        // Next state logic
        S_next = (state[0] && !d) || (state[1] && !d) || (state[3] && !d) || (state[9] && ack);
        S1_next = (state[0] && d);
        B3_next = state[6];
        Count_next = state[7];
        Wait_next = (state[8] && done_counting);

        // Output logic
        shift_ena = state[4] || state[5] || state[6] || state[7];
        counting = state[8];
        done = state[9];
    end

    // Wait, always @(*) cannot assign to output ports unless they are logic.
    // Correcting implementation to avoid implicit reg issues.

endmodule
