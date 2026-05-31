module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // The state machine specifies next-state logic for y[1] based on y and w.
    // However, the prompt says "Implement just the next-state logic for y[1]. The output Y1 is y[1]."
    // This implies Y1 should be the result of the combinational logic for the next state of the y[1] bit.

    logic next_y1;

    // Truth table for next_y[1]:
    // y[2] y[1] y[0] w | next_y1
    // 0    0    0    0 | 0 (B: 001) -> next_y[1] = 0
    // 0    0    0    1 | 0 (A: 000) -> next_y[1] = 0
    // 0    0    1    0 | 1 (C: 010) -> next_y[1] = 1
    // 0    0    1    1 | 1 (D: 011) -> next_y[1] = 1
    // 0    1    0    0 | 0 (E: 100) -> next_y[1] = 0
    // 0    1    0    1 | 1 (D: 011) -> next_y[1] = 1
    // 0    1    1    0 | 0 (F: 101) -> next_y[1] = 0
    // 0    1    1    1 | 0 (A: 000) -> next_y[1] = 0
    // 1    0    0    0 | 0 (E: 100) -> next_y[1] = 0
    // 1    0    0    1 | 1 (D: 011) -> next_y[1] = 1
    // 1    0    1    0 | 1 (C: 010) -> next_y[1] = 1
    // 1    0    1    1 | 1 (D: 011) -> next_y[1] = 1

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
