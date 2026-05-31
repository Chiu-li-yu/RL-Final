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

    // Transitions:
    // A --1--> B, A --0--> A
    // B --1--> C, B --0--> D
    // C --1--> E, C --0--> D
    // D --1--> F, D --0--> A
    // E --1--> E, E --0--> D
    // F --1--> C, F --0--> D

    // Y1 (next state for y[1], which is B):
    // y[1] is 1 if (current state is A AND w=1)
    assign Y1 = (y[0] && w);

    // Y3 (next state for y[3], which is D):
    // y[3] is 1 if (current state is B AND w=0) OR
    //              (current state is C AND w=0) OR
    //              (current state is E AND w=0) OR
    //              (current state is F AND w=0)
    assign Y3 = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[5] && !w);

endmodule