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

    // Decoding state
    logic S, S1, S11, S110, B0, B1, B2, B3, Count, Wait;
    assign {Wait, Count, B3, B2, B1, B0, S110, S11, S1, S} = state;

    // Next State Logic
    always @(*) begin
        next_state = 10'b0;
        case (1'b1)
            S:    next_state = (d) ? 10'b0000000010 : 10'b0000000001;
            S1:   next_state = (d) ? 10'b0000000100 : 10'b0000000001;
            S11:  next_state = (d) ? 10'b0000000100 : 10'b0000001000;
            S110: next_state = (d) ? 10'b0000010000 : 10'b0000000001;
            B0:   next_state = 10'b0000100000;
            B1:   next_state = 10'b0001000000;
            B2:   next_state = 10'b0010000000;
            B3:   next_state = 10'b0100000000;
            Count: next_state = (done_counting) ? 10'b1000000000 : 10'b0100000000;
            Wait:  next_state = (ack) ? 10'b0000000001 : 10'b1000000000;
            default: next_state = 10'b0000000001;
        endcase
    end

    // Output logic
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