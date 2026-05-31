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

    // Encoding (one-hot):
    // S    : state[0]
    // S1   : state[1]
    // S11  : state[2]
    // S110 : state[3]
    // B0   : state[4]
    // B1   : state[5]
    // B2   : state[6]
    // B3   : state[7]
    // Count: state[8]
    // Wait : state[9]

    logic next_S, next_S1, next_S11, next_S110, next_B0, next_B1, next_B2, next_B3, next_Count, next_Wait;

    always @(*) begin
        next_S    = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);
        next_S1   = (state[0] & d) | (state[1] & d);
        next_S11  = (state[1] & d) | (state[2] & d);
        next_S110 = (state[2] & ~d);
        next_B0   = (state[3] & d);
        next_B1   = state[4];
        next_B2   = state[5];
        next_B3   = state[6];
        next_Count= state[7] | (state[8] & ~done_counting);
        next_Wait = (state[8] & done_counting) | (state[9] & ~ack);
    end

    assign S_next = next_S;
    assign S1_next = next_S1;
    assign B3_next = next_B3;
    assign Count_next = next_Count;
    assign Wait_next = next_Wait;

    assign shift_ena = state[4] | state[5] | state[6] | state[7];
    assign counting = state[8];
    assign done = state[9];

endmodule
