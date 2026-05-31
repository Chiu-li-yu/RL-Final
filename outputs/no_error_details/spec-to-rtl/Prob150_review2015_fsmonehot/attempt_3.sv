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

    // Encoding: (S, S1, S11, S110, B0, B1, B2, B3, Count, Wait) = (10'b0000000001, ..., 10'b1000000000)
    // S=bit0, S1=bit1, S11=bit2, S110=bit3, B0=bit4, B1=bit5, B2=bit6, B3=bit7, Count=bit8, Wait=bit9
    logic S, S1, S11, S110, B0, B1, B2, B3, Count, Wait;
    assign {Wait, Count, B3, B2, B1, B0, S110, S11, S1, S} = state; // Wait is MSB 10'b1000000000

    // Re-assigning to clarify indices
    assign S     = state[0];
    assign S1    = state[1];
    assign S11   = state[2];
    assign S110  = state[3];
    assign B0    = state[4];
    assign B1    = state[5];
    assign B2    = state[6];
    assign B3    = state[7];
    assign Count = state[8];
    assign Wait  = state[9];

    // Next State Logic
    always @(*) begin
        next_state = 10'b0;
        if (S)    next_state = (d) ? 10'b0000000010 : 10'b0000000001;
        else if (S1)   next_state = (d) ? 10'b0000000100 : 10'b0000000001;
        else if (S11)  next_state = (d) ? 10'b0000000100 : 10'b0000001000;
        else if (S110) next_state = (d) ? 10'b0000010000 : 10'b0000000001;
        else if (B0)   next_state = 10'b0000100000;
        else if (B1)   next_state = 10'b0001000000;
        else if (B2)   next_state = 10'b0010000000;
        else if (B3)   next_state = 10'b0100000000;
        else if (Count) next_state = (done_counting) ? 10'b1000000000 : 10'b0100000000;
        else if (Wait)  next_state = (ack) ? 10'b0000000001 : 10'b1000000000;
        else next_state = 10'b0000000001;
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