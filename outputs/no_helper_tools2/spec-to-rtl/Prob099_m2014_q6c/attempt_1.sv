module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    // State assignment (one-hot):
    // A: y[0] = 000001
    // B: y[1] = 000010
    // C: y[2] = 000100
    // D: y[3] = 001000
    // E: y[4] = 010000
    // F: y[5] = 100000

    // State transitions:
    // A -> B (w=0), A (w=1)
    // B -> C (w=0), D (w=1)
    // C -> E (w=0), D (w=1)
    // D -> F (w=0), A (w=1)
    // E -> E (w=0), D (w=1)
    // F -> C (w=0), D (w=1)

    // Next states for each state:
    // Next A: (A and w) or (D and !w)
    // Next B: (A and !w)
    // Next C: (B and !w) or (F and !w)
    // Next D: (B and w) or (C and w) or (E and w) or (F and w)
    // Next E: (C and !w) or (E and !w)
    // Next F: (D and !w)

    // Y1 (Next State B):
    // B is reached from A when w=0.
    assign Y1 = (y[0] && !w);

    // Y3 (Next State D):
    // D is reached from B(w=1), C(w=1), E(w=1), F(w=1).
    assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w);

endmodule
