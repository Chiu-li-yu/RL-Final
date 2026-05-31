module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    // State definitions (one-hot):
    // A: y[0] = 000001
    // B: y[1] = 000010
    // C: y[2] = 000100
    // D: y[3] = 001000
    // E: y[4] = 010000
    // F: y[5] = 100000

    // Next state equations based on the transition diagram:
    // Next state A is 1 if (A AND w=1) OR (D AND w=1)
    // Next state B is 1 if (A AND w=0)
    // Next state C is 1 if (B AND w=0) OR (F AND w=0)
    // Next state D is 1 if (B AND w=1) OR (C AND w=1) OR (E AND w=1) OR (F AND w=1)
    // Next state E is 1 if (C AND w=0) OR (E AND w=0)
    // Next state F is 1 if (D AND w=0)

    // Y1 (next state B)
    // Y1 = A & w_bar = y[0] & ~w

    // Y3 (next state D)
    // Y3 = (B & w) | (C & w) | (E & w) | (F & w)
    // Y3 = w & (y[1] | y[2] | y[4] | y[5])

    assign Y1 = y[0] & (~w);
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule
