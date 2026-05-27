module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // Transitions:
    // y(t) | w | y(t+1) | y[1](t+1)
    // -----|---|--------|----------
    // 000  | 0 | 001    | 0
    // 000  | 1 | 000    | 0
    // 001  | 0 | 010    | 1
    // 001  | 1 | 011    | 1
    // 010  | 0 | 100    | 0
    // 010  | 1 | 011    | 1
    // 011  | 0 | 101    | 0
    // 011  | 1 | 000    | 0
    // 100  | 0 | 100    | 0
    // 100  | 1 | 011    | 1
    // 101  | 0 | 010    | 1
    // 101  | 1 | 011    | 1

    // y[1](t+1) truth table:
    // y2 y1 y0 w | Y1
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

    // Let's implement this logic directly.
    logic [2:0] current_state;
    logic next_y1;

    assign current_state = y;

    always @(*) begin
        case (current_state)
            3'b000: next_y1 = 1'b0;
            3'b001: next_y1 = 1'b1;
            3'b010: next_y1 = w ? 1'b1 : 1'b0;
            3'b011: next_y1 = 1'b0;
            3'b100: next_y1 = w ? 1'b1 : 1'b0;
            3'b101: next_y1 = 1'b1;
            default: next_y1 = 1'b0;
        endcase
    end

    assign Y1 = next_y1;

endmodule
