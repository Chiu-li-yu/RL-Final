module TopModule(
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
    // S    = 10'b0000000001
    // S1   = 10'b0000000010
    // S11  = 10'b0000000100
    // S110 = 10'b0000001000
    // B0   = 10'b0000010000
    // B1   = 10'b0000100000
    // B2   = 10'b0001000000
    // B3   = 10'b0010000000
    // Count= 10'b0100000000
    // Wait = 10'b1000000000

    logic [9:0] next_state;

    always @(*) begin
        next_state = 10'b0;
        case (1'b1)
            state[0]: next_state = d ? 10'b0000000010 : 10'b0000000001; // S -> S1 or S
            state[1]: next_state = d ? 10'b0000000100 : 10'b0000000001; // S1 -> S11 or S
            state[2]: next_state = d ? 10'b0000000100 : 10'b0000001000; // S11 -> S11 or S110
            state[3]: next_state = d ? 10'b0000010000 : 10'b0000000001; // S110 -> B0 or S
            state[4]: next_state = 10'b0000100000;                      // B0 -> B1
            state[5]: next_state = 10'b0001000000;                      // B1 -> B2
            state[6]: next_state = 10'b0010000000;                      // B2 -> B3
            state[7]: next_state = 10'b0100000000;                      // B3 -> Count
            state[8]: next_state = done_counting ? 10'b1000000000 : 10'b0100000000; // Count -> Wait or Count
            state[9]: next_state = ack ? 10'b0000000001 : 10'b1000000000;           // Wait -> S or Wait
        endcase
    end

    assign S_next      = next_state[0];
    assign S1_next     = next_state[1];
    assign B3_next     = next_state[7];
    assign Count_next  = next_state[8];
    assign Wait_next   = next_state[9];

    assign shift_ena   = state[4] | state[5] | state[6] | state[7];
    assign counting    = state[8];
    assign done        = state[9];

endmodule
