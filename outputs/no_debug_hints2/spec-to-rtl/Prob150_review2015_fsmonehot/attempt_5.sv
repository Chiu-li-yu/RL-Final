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

    parameter S    = 10'b0000000001;
    parameter S1   = 10'b0000000010;
    parameter S11  = 10'b0000000100;
    parameter S110 = 10'b0000001000;
    parameter B0   = 10'b0000010000;
    parameter B1   = 10'b0000100000;
    parameter B2   = 10'b0001000000;
    parameter B3   = 10'b0010000000;
    parameter Count = 10'b0100000000;
    parameter Wait  = 10'b1000000000;

    logic [9:0] next_state;

    always @(*) begin
        next_state = 10'b0;
        // Correct one-hot logic
        if (state[0]) next_state = d ? S1 : S;      // S
        else if (state[1]) next_state = d ? S11 : S; // S1
        else if (state[2]) next_state = d ? S11 : S110; // S11
        else if (state[3]) next_state = d ? B0 : S;  // S110
        else if (state[4]) next_state = B1;         // B0
        else if (state[5]) next_state = B2;         // B1
        else if (state[6]) next_state = B3;         // B2
        else if (state[7]) next_state = Count;      // B3
        else if (state[8]) next_state = done_counting ? Wait : Count; // Count
        else if (state[9]) next_state = ack ? S : Wait; // Wait
        else next_state = S;
    end

    assign B3_next = next_state[7];
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];

    assign shift_ena = state[4] | state[5] | state[6] | state[7];
    assign counting  = state[8];
    assign done      = state[9];

endmodule
