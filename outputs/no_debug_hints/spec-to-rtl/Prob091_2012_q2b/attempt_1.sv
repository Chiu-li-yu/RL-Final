module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot state assignment:
    // A: 6'b000001 (y[0])
    // B: 6'b000010 (y[1])
    // C: 6'b000100 (y[2])
    // D: 6'b001000 (y[3])
    // E: 6'b010000 (y[4])
    // F: 6'b100000 (y[5])

    // Transitions:
    // A --w=1--> B
    // B --w=1--> C, --w=0--> D
    // C --w=1--> E, --w=0--> D
    // D --w=1--> F, --w=0--> A
    // E --w=1--> E, --w=0--> D
    // F --w=1--> C, --w=0--> D

    // Next state logic:
    // next_A = (D & !w)
    // next_B = (A & w)
    // next_C = (B & w) | (F & w)
    // next_D = (B & !w) | (C & !w) | (E & !w) | (F & !w)
    // next_E = (C & w) | (E & w)
    // next_F = (D & w)

    // Y1 is the input of state flip-flop y[1] (which corresponds to B)
    // Y3 is the input of state flip-flop y[3] (which corresponds to D)

    assign Y1 = (y[0] & w);
    assign Y3 = (y[1] & !w) | (y[2] & !w) | (y[4] & !w) | (y[5] & !w);

endmodule