module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot state mapping:
    // A: y[0] = 000001
    // B: y[1] = 000010
    // C: y[2] = 000100
    // D: y[3] = 001000
    // E: y[4] = 010000
    // F: y[5] = 100000

    // Next State Logic:
    // Y1 (State B):
    // Transition to B happens if:
    // - From A (y[0]) if w=1
    // Y1 = y[0] * w

    // Y3 (State D):
    // Transition to D happens if:
    // - From B (y[1]) if w=0
    // - From C (y[2]) if w=0
    // - From E (y[4]) if w=0
    // - From F (y[5]) if w=0
    // Y3 = (y[1] | y[2] | y[4] | y[5]) * (!w)

    assign Y1 = y[0] & w;
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & (~w);

endmodule