module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot state assignment: 
    // y[0]: A
    // y[1]: B
    // y[2]: C
    // y[3]: D
    // y[4]: E
    // y[5]: F

    // Next State Logic:
    // A (000001) --0--> B (000010)
    // A (000001) --1--> A (000001)
    // B (000010) --0--> C (000100)
    // B (000010) --1--> D (001000)
    // C (000100) --0--> E (010000)
    // C (000100) --1--> D (001000)
    // D (001000) --0--> F (100000)
    // D (001000) --1--> A (000001)
    // E (010000) --0--> E (010000)
    // E (010000) --1--> D (001000)
    // F (100000) --0--> C (000100)
    // F (100000) --1--> D (001000)

    // Output Y1 corresponds to the next state for state B.
    // Looking at the transitions, State B (y[1]) is entered from:
    // - State A, if w=0.
    // Therefore, Y1 = (y[0] & ~w)

    // Output Y3 corresponds to the next state for state D.
    // State D (y[3]) is entered from:
    // - State B, if w=1
    // - State C, if w=1
    // - State E, if w=1
    // - State F, if w=1
    // Therefore, Y3 = (y[1] | y[2] | y[4] | y[5]) & w

    assign Y1 = y[0] & ~w;
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule
