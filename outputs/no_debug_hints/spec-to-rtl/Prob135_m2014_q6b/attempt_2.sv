module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// Truth table for next_y[1]:
// y[2] y[1] y[0] w | next_y1
// 0    0    0    0 | 0
// 0    0    0    1 | 0
// 0    0    1    0 | 1
// 0    0    1    1 | 1
// 0    1    0    0 | 0
// 0    1    0    1 | 1
// 0    1    1    0 | 0
// 0    1    1    1 | 0
// 1    0    0    0 | 0
// 1    0    0    1 | 1
// 1    0    1    0 | 1
// 1    0    1    1 | 1

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
