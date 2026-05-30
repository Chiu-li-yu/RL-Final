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
    // B2    = 10'b0010000000
    // B3    = 10'b0100000000
    // Count = 10'b1000000000
    // Wait  = 10'b10000000000 (Wait is 10th bit)

    // Wait, the state input is 10 bits, but there are 10 states.
    // Let's re-verify the encoding:
    // S     (0) : 10'b0000000001
    // S1    (1) : 10'b0000000010
    // S11   (2) : 10'b0000000100
    // S110  (3) : 10'b0000001000
    // B0    (4) : 10'b0000010000
    // B1    (5) : 10'b0000100000
    // B2    (6) : 10'b0001000000
    // B3    (7) : 10'b0010000000
    // Count (8) : 10'b0100000000
    // Wait  (9) : 10'b1000000000

    logic S, S1, S11, S110, B0, B1, B2, B3, Count, Wait;
    assign {Wait, Count, B3, B2, B1, B0, S110, S11, S1, S} = state;

    // Next state logic
    logic next_S, next_S1, next_S11, next_S110, next_B0, next_B1, next_B2, next_B3, next_Count, next_Wait;

    always @(*) begin
        next_S     = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
        next_S1    = (S & d);
        next_S11   = (S1 & d) | (S11 & d);
        next_S110  = (S11 & ~d);
        next_B0    = (S110 & d);
        next_B1    = B0;
        next_B2    = B1;
        next_B3    = B2;
        next_Count = B3 | (Count & ~done_counting);
        next_Wait  = (Count & done_counting) | (Wait & ~ack);
    end

    assign B3_next    = next_B3;
    assign S_next     = next_S;
    assign S1_next    = next_S1;
    assign Count_next = next_Count;
    assign Wait_next  = next_Wait;

    // Output logic
    assign shift_ena = B0 | B1 | B2 | B3;
    assign counting  = Count;
    assign done      = Wait;

endmodule
