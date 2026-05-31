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

    // Next state logic derived from transitions:
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

    // Y1 (Next state B):
    // Transitioning to B happens if (Current State is A) AND (w == 0)
    assign Y1 = (y[0] && !w);

    // Y3 (Next state D):
    // Transitioning to D happens if:
    // (Current State is B) AND (w == 1)
    // (Current State is C) AND (w == 1)
    // (Current State is E) AND (w == 1)
    // (Current State is F) AND (w == 1)
    assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w);

endmodule
