module TopModule (
    input logic d,
    input logic done_counting,
    input logic ack,
    input logic [9:0] state,
    output logic B3_next,
    output logic S_next,
    output logic S1_next,
    output logic Count_next,
    output logic Wait_next,
    output logic done,
    output logic counting,
    output logic shift_ena
);

    // Encoding: (S, S1, S11, S110, B0, B1, B2, B3, Count, Wait)
    // Indices:   0,  1,   2,    3,  4,  5,  6,  7,     8,    9
    logic S, S1, S11, S110, B0, B1, B2, B3, Count, Wait;
    assign {Wait, Count, B3, B2, B1, B0, S110, S11, S1, S} = state;

    logic n_S, n_S1, n_S11, n_S110, n_B0, n_B1, n_B2, n_B3, n_Count, n_Wait;

    always @(*) begin
        // S transitions: S --d=0--> S, S --d=1--> S1
        // S1 transitions: S1 --d=0--> S, S1 --d=1--> S11
        // S11 transitions: S11 --d=0--> S110, S11 --d=1--> S11
        // S110 transitions: S110 --d=0--> S, S110 --d=1--> B0
        n_S    = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
        n_S1   = (S & d);
        n_S11  = (S1 & d) | (S11 & d);
        n_S110 = (S11 & ~d);
        n_B0   = (S110 & d);
        n_B1   = B0;
        n_B2   = B1;
        n_B3   = B2;
        n_Count = B3 | (Count & ~done_counting);
        n_Wait  = (Count & done_counting) | (Wait & ~ack);

        // Assign output signals for next state
        S_next = n_S;
        S1_next = n_S1;
        B3_next = n_B3;
        Count_next = n_Count;
        Wait_next = n_Wait;

        // Output logic based on current state
        shift_ena = B0 | B1 | B2 | B3;
        counting  = Count;
        done      = Wait;
    end
endmodule
