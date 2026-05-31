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

    // Encoding from spec: (S, S1, S11, S110, B0, B1, B2, B3, Count, Wait)
    // S    = 10'b0000000001
    // S1   = 10'b0000000010
    // S11  = 10'b0000000100
    // S110 = 10'b0000001000
    // B0   = 10'b0000010000
    // B1   = 10'b0000100000
    // B2   = 10'b0001000000
    // B3   = 10'b0010000000
    // Count = 10'b0100000000
    // Wait  = 10'b1000000000

    logic S, S1, S11, S110, B0, B1, B2, B3, Count, Wait;
    assign {Wait, Count, B3, B2, B1, B0, S110, S11, S1, S} = state;

    logic nS, nS1, nS11, nS110, nB0, nB1, nB2, nB3, nCount, nWait;

    always @(*) begin
        nS    = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
        nS1   = (S & d) | (S11 & d); // Corrected logic: S1 & d moves to S11, so it shouldn't be here. 
        // Wait, re-reading: 
        // S1 -> d=1 -> S11
        // S1 -> d=0 -> S
        // Let's re-verify nS1:
        // S -> d=1 -> S1
        // S1 -> d=1 -> S11
        // nS1 should be (S & d)
    end

    // Let's rewrite carefully:
    // S    --d=0--> S
    // S    --d=1--> S1
    // S1   --d=0--> S
    // S1   --d=1--> S11
    // S11  --d=0--> S110
    // S11  --d=1--> S11
    // S110 --d=0--> S
    // S110 --d=1--> B0
    // B0 -> B1
    // B1 -> B2
    // B2 -> B3
    // B3 -> Count
    // Count --d_c=0--> Count
    // Count --d_c=1--> Wait
    // Wait --ack=0--> Wait
    // Wait --ack=1--> S

    always @(*) begin
        nS    = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
        nS1   = (S & d);
        nS11  = (S1 & d) | (S11 & d);
        nS110 = (S11 & ~d);
        nB0   = (S110 & d);
        nB1   = B0;
        nB2   = B1;
        nB3   = B2;
        nCount = B3 | (Count & ~done_counting);
        nWait  = (Count & done_counting) | (Wait & ~ack);
    end

    assign B3_next = nB3;
    assign S_next = nS;
    assign S1_next = nS1;
    assign Count_next = nCount;
    assign Wait_next = nWait;

    assign shift_ena = B0 | B1 | B2 | B3;
    assign counting = Count;
    assign done = Wait;

endmodule
