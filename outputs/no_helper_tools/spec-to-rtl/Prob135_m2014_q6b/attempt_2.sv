module TopModule (
    input [2:0] y,
    input w,
    output Y1
);
    // The problem asks to implement the next-state logic for y[1].
    // Let's derive the truth table for next_y[1] based on the FSM.

    // A (000) --0--> B (001) : next_y = 001, next_y[1] = 0
    // A (000) --1--> A (000) : next_y = 000, next_y[1] = 0
    // B (001) --0--> C (010) : next_y = 010, next_y[1] = 1
    // B (001) --1--> D (011) : next_y = 011, next_y[1] = 1
    // C (010) --0--> E (100) : next_y = 100, next_y[1] = 0
    // C (010) --1--> D (011) : next_y = 011, next_y[1] = 1
    // D (011) --0--> F (101) : next_y = 101, next_y[1] = 0
    // D (011) --1--> A (000) : next_y = 000, next_y[1] = 0
    // E (100) --0--> E (100) : next_y = 100, next_y[1] = 0
    // E (100) --1--> D (011) : next_y = 011, next_y[1] = 1
    // F (101) --0--> C (010) : next_y = 010, next_y[1] = 1
    // F (101) --1--> D (011) : next_y = 011, next_y[1] = 1

    // Mapping y[2:0] and w to next_y[1]:
    // y2 y1 y0 w | next_y1
    // 0  0  0  0 | 0
    // 0  0  0  1 | 0
    // 0  0  1  0 | 1
    // 0  0  1  1 | 1
    // 0  1  0  0 | 0
    // 0  1  0  1 | 1
    // 0  1  1  0 | 0
    // 0  1  1  1 | 0
    // 1  0  0  0 | 0
    // 1  0  0  1 | 1
    // 1  0  1  0 | 1
    // 1  0  1  1 | 1

    logic next_y1;
    always @(*) begin
        case ({y, w})
            4'b000_0: next_y1 = 0;
            4'b000_1: next_y1 = 0;
            4'b001_0: next_y1 = 1;
            4'b001_1: next_y1 = 1;
            4'b010_0: next_y1 = 0;
            4'b010_1: next_y1 = 1;
            4'b011_0: next_y1 = 0;
            4'b011_1: next_y1 = 0;
            4'b100_0: next_y1 = 0;
            4'b100_1: next_y1 = 1;
            4'b101_0: next_y1 = 1;
            4'b101_1: next_y1 = 1;
            default:  next_y1 = 0;
        endcase
    end

    assign Y1 = next_y1;
endmodule
