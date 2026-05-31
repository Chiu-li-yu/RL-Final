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

    // Next State Logic:
    // A(0) --0--> B, A(0) --1--> A
    // B(0) --0--> C, B(0) --1--> D
    // C(0) --0--> E, C(0) --1--> D
    // D(0) --0--> F, D(0) --1--> A
    // E(1) --0--> E, E(1) --1--> D
    // F(1) --0--> C, F(1) --1--> D

    // Next state A (Y0) is true if:
    // (A AND w) OR (D AND w)
    // Next state B (Y1) is true if:
    // (A AND !w)
    // Next state C (Y2) is true if:
    // (B AND !w) OR (F AND !w)
    // Next state D (Y3) is true if:
    // (B AND w) OR (C AND w) OR (E AND w) OR (F AND w)
    // Next state E (Y4) is true if:
    // (C AND !w) OR (E AND !w)
    // Next state F (Y5) is true if:
    // (D AND !w)

    // Y1 (Next B):
    assign Y1 = (y[0] && !w);
    
    // Y3 (Next D):
    assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w);

endmodule
