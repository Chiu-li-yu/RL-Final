module TopModule(
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

    // Transitions (current_state --w--> next_state):
    // A --0--> B
    // A --1--> A
    // B --0--> C
    // B --1--> D
    // C --0--> E
    // C --1--> D
    // D --0--> F
    // D --1--> A
    // E --0--> E
    // E --1--> D
    // F --0--> C
    // F --1--> D

    // Next State Logic:
    // Next A = (A & w) | (D & ~w)
    // Next B = (A & ~w)
    // Next C = (B & ~w) | (F & ~w)
    // Next D = (B & w) | (C & w) | (E & w) | (F & w)
    // Next E = (C & ~w) | (E & ~w)
    // Next F = (D & ~w)

    // Output mapping (requested Y1 for y[1] and Y3 for y[3]):
    // Since it's one-hot:
    // Y1 is the next state for state B (y[1])
    // Y3 is the next state for state D (y[3])
    
    // Actually, reading the prompt: "The module should implement the next-state signals Y2 and Y4 corresponding to signal y[1] and y[3]."
    // The prompt then asks for outputs Y1 and Y3 corresponding to states y[1] and y[3].
    // Given the names, let's map Y1 to NextState_y[1] and Y3 to NextState_y[3].

    assign Y1 = (y[0] & ~w);
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule
