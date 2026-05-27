module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // State assignment (One-Hot)
    // A: y[0] = 000001
    // B: y[1] = 000010
    // C: y[2] = 000100
    // D: y[3] = 001000
    // E: y[4] = 010000
    // F: y[5] = 100000

    // Transitions:
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

    // Y[i] is the next state bit i
    // Y[1] (State B):
    // From A, if w=0 -> A --0--> B
    // So Y[1] = A & (~w) = y[0] & (~w)

    // Y[3] (State D):
    // From B, if w=1 -> B --1--> D
    // From C, if w=1 -> C --1--> D
    // From E, if w=1 -> E --1--> D
    // From F, if w=1 -> F --1--> D
    // So Y[3] = (B & w) | (C & w) | (E & w) | (F & w)
    //         = w & (y[1] | y[2] | y[4] | y[5])

    assign Y1 = y[0] & (~w);
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule
