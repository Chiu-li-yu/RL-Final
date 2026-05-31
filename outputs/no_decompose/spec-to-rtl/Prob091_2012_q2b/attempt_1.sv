module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    // State assignment (one-hot):
    // A: 6'b000001
    // B: 6'b000010
    // C: 6'b000100
    // D: 6'b001000
    // E: 6'b010000
    // F: 6'b100000

    // Transitions:
    // A --1--> B,  A --0--> A
    // B --1--> C,  B --0--> D
    // C --1--> E,  C --0--> D
    // D --1--> F,  D --0--> A
    // E --1--> E,  E --0--> D
    // F --1--> C,  F --0--> D

    // Y1 (input to y[1], which corresponds to state B)
    // Next state is B if:
    // (Current state A AND w==1)
    assign Y1 = (y[0] && w);

    // Y3 (input to y[3], which corresponds to state D)
    // Next state is D if:
    // (Current state B AND w==0) OR
    // (Current state C AND w==0) OR
    // (Current state E AND w==0) OR
    // (Current state F AND w==0)
    assign Y3 = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[5] && !w);

endmodule
