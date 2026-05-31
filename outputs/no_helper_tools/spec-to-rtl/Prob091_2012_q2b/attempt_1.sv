module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot assignment:
    // y[0]: A, y[1]: B, y[2]: C, y[3]: D, y[4]: E, y[5]: F
    
    // Transitions:
    // A (000001) --w=1--> B (000010)
    // A (000001) --w=0--> A (000001)
    // B (000010) --w=1--> C (000100)
    // B (000010) --w=0--> D (001000)
    // C (000100) --w=1--> E (010000)
    // C (000100) --w=0--> D (001000)
    // D (001000) --w=1--> F (100000)
    // D (001000) --w=0--> A (000001)
    // E (010000) --w=1--> E (010000)
    // E (010000) --w=0--> D (001000)
    // F (100000) --w=1--> C (000100)
    // F (100000) --w=0--> D (001000)

    // Y1 (next state for y[1] i.e., state B):
    // B is reached from:
    // - A when w=1
    logic Y1_comb;
    assign Y1_comb = (y[0] && w);
    assign Y1 = Y1_comb;

    // Y3 (next state for y[3] i.e., state D):
    // D is reached from:
    // - B when w=0
    // - C when w=0
    // - E when w=0
    // - F when w=0
    logic Y3_comb;
    assign Y3_comb = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[5] && !w);
    assign Y3 = Y3_comb;

endmodule
