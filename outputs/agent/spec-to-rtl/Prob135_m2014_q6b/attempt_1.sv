module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // Current State (y) to Next State (next_y) mapping:
    // A (000) --0--> B (001) -> next_y[1] = 0
    // A (000) --1--> A (000) -> next_y[1] = 0
    // B (001) --0--> C (010) -> next_y[1] = 1
    // B (001) --1--> D (011) -> next_y[1] = 1
    // C (010) --0--> E (100) -> next_y[1] = 0
    // C (010) --1--> D (011) -> next_y[1] = 1
    // D (011) --0--> F (101) -> next_y[1] = 0
    // D (011) --1--> A (000) -> next_y[1] = 0
    // E (100) --0--> E (100) -> next_y[1] = 0
    // E (100) --1--> D (011) -> next_y[1] = 1
    // F (101) --0--> C (010) -> next_y[1] = 1
    // F (101) --1--> D (011) -> next_y[1] = 1

    // Mapping table for next_y[1]:
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
            4'b0000: next_y1 = 0;
            4'b0001: next_y1 = 0;
            4'b0010: next_y1 = 1;
            4'b0011: next_y1 = 1;
            4'b0100: next_y1 = 0;
            4'b0101: next_y1 = 1;
            4'b0110: next_y1 = 0;
            4'b0111: next_y1 = 0;
            4'b1000: next_y1 = 0;
            4'b1001: next_y1 = 1;
            4'b1010: next_y1 = 1;
            4'b1011: next_y1 = 1;
            default: next_y1 = 0;
        endcase
    end

    assign Y1 = next_y1;

endmodule
