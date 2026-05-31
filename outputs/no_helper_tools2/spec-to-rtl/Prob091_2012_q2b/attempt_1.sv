module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot assignment:
    // A: y[0] = 000001
    // B: y[1] = 000010
    // C: y[2] = 000100
    // D: y[3] = 001000
    // E: y[4] = 010000
    // F: y[5] = 100000

    // State transitions (Next State Logic):
    // A (000001) --1--> B (y[1])
    // A (000001) --0--> A (y[0])
    // B (000010) --1--> C (y[2])
    // B (000010) --0--> D (y[3])
    // C (000100) --1--> E (y[4])
    // C (000100) --0--> D (y[3])
    // D (001000) --1--> F (y[5])
    // D (001000) --0--> A (y[0])
    // E (010000) --1--> E (y[4])
    // E (010000) --0--> D (y[3])
    // F (100000) --1--> C (y[2])
    // F (100000) --0--> D (y[3])

    // Y1 (Next state for y[1]):
    // y[1] is 1 if (State is A AND w=1)
    assign Y1 = (y[0] && w);

    // Y3 (Next state for y[3]):
    // y[3] is 1 if (State is B AND w=0) OR (State is C AND w=0) OR (State is E AND w=0) OR (State is F AND w=0)
    assign Y3 = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[5] && !w);

endmodule
