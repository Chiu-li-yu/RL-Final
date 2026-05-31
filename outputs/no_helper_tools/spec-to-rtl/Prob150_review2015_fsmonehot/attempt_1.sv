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
    // S     = 10'b0000000001
    // S1    = 10'b0000000010
    // S11   = 10'b0000000100
    // S110  = 10'b0000001000
    // B0    = 10'b0000010000
    // B1    = 10'b0000100000
    // B2    = 10'b0001000000
    // B3    = 10'b0010000000
    // Count = 10'b0100000000
    // Wait  = 10'b1000000000

    logic S, S1, S11, S110, B0, B1, B2, B3, Count, Wait;
    assign {Wait, Count, B3, B2, B1, B0, S110, S11, S1, S} = state;

    logic n_S, n_S1, n_S11, n_S110, n_B0, n_B1, n_B2, n_B3, n_Count, n_Wait;

    always @(*) begin
        n_S     = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
        n_S1    = (S & d) | (S1 & d);
        n_S11   = (S1 & d) | (S11 & d);
        n_S110  = (S11 & ~d);
        n_B0    = (S110 & d);
        n_B1    = B0;
        n_B2    = B1;
        n_B3    = B2;
        n_Count = B3 | (Count & ~done_counting);
        n_Wait  = (Count & done_counting) | (Wait & ~ack);
    end

    assign B3_next    = n_B3;
    assign S_next     = n_S;
    assign S1_next    = n_S1;
    assign Count_next = n_Count;
    assign Wait_next  = n_Wait;

    assign shift_ena = B0 | B1 | B2 | B3;
    assign counting  = Count;
    assign done      = Wait;

endmodule
