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

    // Encoding: (S, S1, S11, S110, B0, B1, B2, B3, Count, Wait)
    // S=0, S1=1, S11=2, S110=3, B0=4, B1=5, B2=6, B3=7, Count=8, Wait=9
    logic [9:0] next_state;

    always @(*) begin
        next_state = 10'b0;
        case (1'b1)
            state[0]: next_state = d ? 10'b0000000010 : 10'b0000000001; // S
            state[1]: next_state = d ? 10'b0000000100 : 10'b0000000001; // S1
            state[2]: next_state = d ? 10'b0000000100 : 10'b0000001000; // S11
            state[3]: next_state = d ? 10'b0000010000 : 10'b0000000001; // S110
            state[4]: next_state = 10'b0000100000;                     // B0
            state[5]: next_state = 10'b0001000000;                     // B1
            state[6]: next_state = 10'b0010000000;                     // B2
            state[7]: next_state = 10'b0100000000;                     // B3
            state[8]: next_state = done_counting ? 10'b1000000000 : 10'b0100000000; // Count
            state[9]: next_state = ack ? 10'b0000000001 : 10'b1000000000;          // Wait
            default: next_state = 10'b0000000001;
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