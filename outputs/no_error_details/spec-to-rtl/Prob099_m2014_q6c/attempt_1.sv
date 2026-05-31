module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot state assignment:
    // A: y[0] = 000001
    // B: y[1] = 000010
    // C: y[2] = 000100
    // D: y[3] = 001000
    // E: y[4] = 010000
    // F: y[5] = 100000

    // State transitions:
    // A --0--> B
    // A --1--> A
    // B --0--> C
    // B --1--> D
    // C --0--> E
    // C --1--> D
    // D --0--> F
    // D --1--> A
    // E --0--> E
    // E --1--> D
    // F --0--> C
    // F --1--> D

    // Y1 is the next state bit for state B (y[1])
    // Y1 = 1 when transition to B occurs
    // Transitions to B:
    // A --0--> B (A is y[0], w is 0)
    assign Y1 = (y[0] && !w);

    // Y3 is the next state bit for state D (y[3])
    // Y3 = 1 when transition to D occurs
    // Transitions to D:
    // B --1--> D (B is y[1], w is 1)
    // C --1--> D (C is y[2], w is 1)
    // E --1--> D (E is y[4], w is 1)
    // F --1--> D (F is y[5], w is 1)
    assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w);

endmodule
