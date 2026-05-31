module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // Current State | Input w | Next State | Next y[1]
    // 000 (A)       | 0       | 001        | 0
    // 000 (A)       | 1       | 000        | 0
    // 001 (B)       | 0       | 010        | 1
    // 001 (B)       | 1       | 011        | 1
    // 010 (C)       | 0       | 100        | 0
    // 010 (C)       | 1       | 011        | 1
    // 011 (D)       | 0       | 101        | 0
    // 011 (D)       | 1       | 000        | 0
    // 100 (E)       | 0       | 100        | 0
    // 100 (E)       | 1       | 011        | 1
    // 101 (F)       | 0       | 010        | 1
    // 101 (F)       | 1       | 011        | 1

    logic next_y1;

    always @(*) begin
        case ({y, w})
            4'b0000: next_y1 = 1'b0;
            4'b0001: next_y1 = 1'b0;
            4'b0010: next_y1 = 1'b1;
            4'b0011: next_y1 = 1'b1;
            4'b0100: next_y1 = 1'b0;
            4'b0101: next_y1 = 1'b1;
            4'b0110: next_y1 = 1'b0;
            4'b0111: next_y1 = 1'b0;
            4'b1000: next_y1 = 1'b0;
            4'b1001: next_y1 = 1'b1;
            4'b1010: next_y1 = 1'b1;
            4'b1011: next_y1 = 1'b1;
            default: next_y1 = 1'b0;
        endcase
    end

    assign Y1 = next_y1;

endmodule
