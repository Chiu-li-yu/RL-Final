module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    // State assignment:
    // A: y[0] = 000001
    // B: y[1] = 000010
    // C: y[2] = 000100
    // D: y[3] = 001000
    // E: y[4] = 010000
    // F: y[5] = 100000

    // State transitions:
    // A --w=1--> B
    // A --w=0--> A
    // B --w=1--> C
    // B --w=0--> D
    // C --w=1--> E
    // C --w=0--> D
    // D --w=1--> F
    // D --w=0--> A
    // E --w=1--> E
    // E --w=0--> D
    // F --w=1--> C
    // F --w=0--> D

    // Y1 (Next state for B): 
    // B is reached from A when w=1.
    // So Y1 = (y[0] and w)
    assign Y1 = (y[0] & w);

    // Y3 (Next state for D):
    // D is reached from B when w=0, from C when w=0, from E when w=0, from F when w=0.
    // So Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w)
    // Simplified: Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule
