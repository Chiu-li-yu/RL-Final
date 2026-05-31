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

    // Encoding:
    // S: 10'b0000000001 (0)
    // S1: 10'b0000000010 (1)
    // S11: 10'b0000000100 (2)
    // S110: 10'b0000001000 (3)
    // B0: 10'b0000010000 (4)
    // B1: 10'b0000100000 (5)
    // B2: 10'b0001000000 (6)
    // B3: 10'b0010000000 (7)
    // Count: 10'b0100000000 (8)
    // Wait: 10'b1000000000 (9)

    logic [9:0] next_state;

    always @(*) begin
        next_state = 10'b0;
        // Current state: state
        // S (state[0]) --d=0--> S, --d=1--> S1
        // S1 (state[1]) --d=0--> S, --d=1--> S11
        // S11 (state[2]) --d=0--> S110, --d=1--> S11
        // S110 (state[3]) --d=0--> S, --d=1--> B0
        // B0 (state[4]) --> B1
        // B1 (state[5]) --> B2
        // B2 (state[6]) --> B3
        // B3 (state[7]) --> Count
        // Count (state[8]) --done_counting=0--> Count, --done_counting=1--> Wait
        // Wait (state[9]) --ack=0--> Wait, --ack=1--> S

        if (state[0]) next_state = d ? 10'b0000000010 : 10'b0000000001;
        else if (state[1]) next_state = d ? 10'b0000000100 : 10'b0000000001;
        else if (state[2]) next_state = d ? 10'b0000000100 : 10'b0000001000;
        else if (state[3]) next_state = d ? 10'b0000010000 : 10'b0000000001;
        else if (state[4]) next_state = 10'b0000100000;
        else if (state[5]) next_state = 10'b0001000000;
        else if (state[6]) next_state = 10'b0010000000;
        else if (state[7]) next_state = 10'b0100000000;
        else if (state[8]) next_state = done_counting ? 10'b1000000000 : 10'b0100000000;
        else if (state[9]) next_state = ack ? 10'b0000000001 : 10'b1000000000;
    end

    // Next State Assertions
    assign S_next     = next_state[0];
    assign S1_next    = next_state[1];
    assign B3_next    = next_state[7];
    assign Count_next = next_state[8];
    assign Wait_next  = next_state[9];

    // Output Logic
    assign shift_ena = state[4] | state[5] | state[6] | state[7];
    assign counting  = state[8];
    assign done      = state[9];

endmodule
