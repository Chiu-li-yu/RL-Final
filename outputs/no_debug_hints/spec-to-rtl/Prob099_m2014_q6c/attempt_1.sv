module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot state assignment:
    // A (000001), B (000010), C (000100), D (001000), E (010000), F (100000)
    // y[0]: A, y[1]: B, y[2]: C, y[3]: D, y[4]: E, y[5]: F

    // Next State Logic:
    // A -> 0 -> B, 1 -> A
    // B -> 0 -> C, 1 -> D
    // C -> 0 -> E, 1 -> D
    // D -> 0 -> F, 1 -> A
    // E -> 0 -> E, 1 -> D
    // F -> 0 -> C, 1 -> D

    // Next State B (y[1]):
    // If current state A and w=0, then next state is B.
    // Y1 = (y[0] & ~w)
    
    // Next State D (y[3]):
    // If current state B and w=1, then next state is D.
    // If current state C and w=1, then next state is D.
    // If current state E and w=1, then next state is D.
    // If current state F and w=1, then next state is D.
    // Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w)

    assign Y1 = (y[0] & ~w);
    assign Y3 = ((y[1] | y[2] | y[4] | y[5]) & w);

endmodule