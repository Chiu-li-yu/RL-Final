module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // State encoding:
    // A: 000
    // B: 001
    // C: 010
    // D: 011
    // E: 100
    // F: 101

    // State variables:
    // y[2] = s2, y[1] = s1, y[0] = s0

    // Next state logic:
    // From A (000): 0 -> B (001), 1 -> A (000)
    // From B (001): 0 -> C (010), 1 -> D (011)
    // From C (010): 0 -> E (100), 1 -> D (011)
    // From D (011): 0 -> F (101), 1 -> A (000)
    // From E (100): 0 -> E (100), 1 -> D (011)
    // From F (101): 0 -> C (010), 1 -> D (011)

    // Current next_y[1] table:
    // y2 y1 y0 w | next_y1
    // 0  0  0  0 | 0 (B: 001)
    // 0  0  0  1 | 0 (A: 000)
    // 0  0  1  0 | 1 (C: 010)
    // 0  0  1  1 | 1 (D: 011)
    // 0  1  0  0 | 0 (E: 100)
    // 0  1  0  1 | 1 (D: 011)
    // 0  1  1  0 | 0 (F: 101)
    // 0  1  1  1 | 0 (A: 000)
    // 1  0  0  0 | 0 (E: 100)
    // 1  0  0  1 | 1 (D: 011)
    // 1  0  1  0 | 1 (C: 010)
    // 1  0  1  1 | 1 (D: 011)

    // Using Karnaugh map or simplification:
    // Y1 = (~y2 & ~y1 & y0) | (~y1 & y0 & w) | (~y2 & y1 & ~y0 & w) | (y2 & ~y1 & ~w) | (y2 & ~y1 & w) | (y2 & ~y1 & y0)
    // Actually, simple SOP:
    // next_y1 = (~y2 & ~y1 & y0) | (y2 & ~y1) | (~y2 & y1 & ~y0 & w) | (y2 & ~y1 & y0) is redundant.

    logic next_y1;

    always @(*) begin
        case ({y, w})
            4'b000_0: next_y1 = 0; // B
            4'b000_1: next_y1 = 0; // A
            4'b001_0: next_y1 = 1; // C
            4'b001_1: next_y1 = 1; // D
            4'b010_0: next_y1 = 0; // E
            4'b010_1: next_y1 = 1; // D
            4'b011_0: next_y1 = 0; // F
            4'b011_1: next_y1 = 0; // A
            4'b100_0: next_y1 = 0; // E
            4'b100_1: next_y1 = 1; // D
            4'b101_0: next_y1 = 1; // C
            4'b101_1: next_y1 = 1; // D
            default: next_y1 = 0;
        endcase
    end

    assign Y1 = y[1];

endmodule
