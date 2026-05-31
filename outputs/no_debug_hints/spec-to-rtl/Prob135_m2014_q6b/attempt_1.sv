module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // State definitions
    // A: 000, B: 001, C: 010, D: 011, E: 100, F: 101

    // State y is 3 bits: y[2], y[1], y[0]
    // Next state logic derived from the state machine:
    // Present State (y) | w | Next State (ny)
    // ------------------|---|----------------
    // A (000)           | 0 | B (001)
    // A (000)           | 1 | A (000)
    // B (001)           | 0 | C (010)
    // B (001)           | 1 | D (011)
    // C (010)           | 0 | E (100)
    // C (010)           | 1 | D (011)
    // D (011)           | 0 | F (101)
    // D (011)           | 1 | A (000)
    // E (100)           | 0 | E (100)
    // E (100)           | 1 | D (011)
    // F (101)           | 0 | C (010)
    // F (101)           | 1 | D (011)

    // Next state table for y[1]:
    // Current (y) | w | ny[1]
    // ------------|---|------
    // 000         | 0 | 0
    // 000         | 1 | 0
    // 001         | 0 | 1
    // 001         | 1 | 1
    // 010         | 0 | 0
    // 010         | 1 | 1
    // 011         | 0 | 0
    // 011         | 1 | 0
    // 100         | 0 | 0
    // 100         | 1 | 1
    // 101         | 0 | 1
    // 101         | 1 | 1

    assign Y1 = y[1];

endmodule
