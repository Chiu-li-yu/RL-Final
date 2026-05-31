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

    // Encoding (one-hot)
    localparam S    = 10'b0000000001;
    localparam S1   = 10'b0000000010;
    localparam S11  = 10'b0000000100;
    localparam S110 = 10'b0000001000;
    localparam B0   = 10'b0000010000;
    localparam B1   = 10'b0000100000;
    localparam B2   = 10'b0001000000;
    localparam B3   = 10'b0010000000;
    localparam Count= 10'b0100000000;
    localparam Wait = 10'b1000000000;

    logic [9:0] next_state;

    always @(*) begin
        // Reset condition is handled by the higher-level FSM which provides state input
        // Here we just define the transition logic based on the one-hot encoding input
        next_state = 10'b0;
        if (state[0]) next_state = d ? S1 : S;         // S
        else if (state[1]) next_state = d ? S11 : S;    // S1
        else if (state[2]) next_state = d ? S11 : S110; // S11
        else if (state[3]) next_state = d ? B0 : S;     // S110
        else if (state[4]) next_state = B1;             // B0
        else if (state[5]) next_state = B2;             // B1
        else if (state[6]) next_state = B3;             // B2
        else if (state[7]) next_state = Count;          // B3
        else if (state[8]) next_state = done_counting ? Wait : Count; // Count
        else if (state[9]) next_state = ack ? S : Wait; // Wait
    end

    // Outputs logic
    assign shift_ena = state[4] || state[5] || state[6] || state[7];
    assign counting  = state[8];
    assign done      = state[9];

    // Next state outputs
    assign B3_next    = next_state[7];
    assign S_next     = next_state[0];
    assign S1_next    = next_state[1];
    assign Count_next = next_state[8];
    assign Wait_next  = next_state[9];

endmodule