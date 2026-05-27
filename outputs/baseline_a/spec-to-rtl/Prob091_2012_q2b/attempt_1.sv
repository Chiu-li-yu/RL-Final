module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // State assignment (one-hot):
    // A: 000001 (y[0])
    // B: 000010 (y[1])
    // C: 000100 (y[2])
    // D: 001000 (y[3])
    // E: 010000 (y[4])
    // F: 100000 (y[5])

    // State transitions:
    // A --1--> B
    // A --0--> A
    // B --1--> C
    // B --0--> D
    // C --1--> E
    // C --0--> D
    // D --1--> F
    // D --0--> A
    // E --1--> E
    // E --0--> D
    // F --1--> C
    // F --0--> D

    // Y1 (next state of B) is high if current state is A and w=1
    assign Y1 = (y[0] & w);

    // Y3 (next state of D) is high if:
    // (current state is B and w=0) or
    // (current state is C and w=0) or
    // (current state is E and w=0) or
    // (current state is F and w=0)
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);

endmodule