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

    logic [9:0] next_state;

    // Mapping one-hot state signals based on order: (S, S1, S11, S110, B0, B1, B2, B3, Count, Wait)
    logic S, S1, S11, S110, B0, B1, B2, B3, Count, Wait;
    assign {Wait, Count, B3, B2, B1, B0, S110, S11, S1, S} = state;

    // Next State Logic
    always @(*) begin
        next_state = 10'b0;
        // The diagram order given: S, S1, S11, S110, B0, B1, B2, B3, Count, Wait
        // Encoding: (S, S1, S11, S110, B0, B1, B2, B3, Count, Wait) = 10'b...
        // Let's re-verify order from: "S, S1, S11, S110, B0, B1, B2, B3, Count, Wait"
        // One-hot indices:
        // S = 0
        // S1 = 1
        // S11 = 2
        // S110 = 3
        // B0 = 4
        // B1 = 5
        // B2 = 6
        // B3 = 7
        // Count = 8
        // Wait = 9
        
        if (S) next_state = (d) ? 10'b0000000010 : 10'b0000000001;
        else if (S1) next_state = (d) ? 10'b0000000100 : 10'b0000000001;
        else if (S11) next_state = (d) ? 10'b0000000100 : 10'b0000001000;
        else if (S110) next_state = (d) ? 10'b0000010000 : 10'b0000000001;
        else if (B0) next_state = 10'b0000100000;
        else if (B1) next_state = 10'b0001000000;
        else if (B2) next_state = 10'b0010000000;
        else if (B3) next_state = 10'b0100000000;
        else if (Count) next_state = (done_counting) ? 10'b1000000000 : 10'b0100000000;
        else if (Wait) next_state = (ack) ? 10'b0000000001 : 10'b1000000000;
        else next_state = 10'b0000000001;
    end

    // Output logic (Moore: only depends on current state)
    assign shift_ena = B0 | B1 | B2 | B3;
    assign counting  = Count;
    assign done      = Wait;

    // Next state helper outputs
    assign S_next     = next_state[0];
    assign S1_next    = next_state[1];
    assign B3_next    = next_state[7];
    assign Count_next = next_state[8];
    assign Wait_next  = next_state[9];

endmodule