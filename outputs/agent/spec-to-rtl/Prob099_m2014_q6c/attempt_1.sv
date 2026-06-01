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

    // State transitions:
    // A --0--> B (y[1] next)
    // A --1--> A
    // B --0--> C
    // B --1--> D (y[3] next)
    // C --0--> E
    // C --1--> D (y[3] next)
    // D --0--> F
    // D --1--> A
    // E --0--> E (y[4] next)
    // E --1--> D (y[3] next)
    // F --0--> C
    // F --1--> D (y[3] next)

    // Next State Logic:
    // Y[1] = (y[0] & ~w)
    // Y[3] = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w)
    
    // Simplify Y3:
    // Y3 = w & (y[1] | y[2] | y[4] | y[5])

    assign Y1 = (y[0] & ~w);
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule
