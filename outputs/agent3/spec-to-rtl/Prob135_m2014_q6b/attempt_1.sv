module TopModule (
    input [2:0] y,
    input w,
    output Y1
);
    // State definitions
    // A: 000, B: 001, C: 010, D: 011, E: 100, F: 101

    // Determine Next State (ns) for each state and w
    // State | w=0 | w=1
    // ------------------
    // A(000)| B(001)| A(000)
    // B(001)| C(010)| D(011)
    // C(010)| E(100)| D(011)
    // D(011)| F(101)| A(000)
    // E(100)| E(100)| D(011)
    // F(101)| C(010)| D(011)

    // Extract next_y[1] (the bit we need to compute)
    // State | w=0 | w=1
    // ------------------
    // A(000)| 0 | 0
    // B(001)| 1 | 1
    // C(010)| 0 | 1
    // D(011)| 0 | 0
    // E(100)| 0 | 1
    // F(101)| 1 | 1

    // Logic for Y1_next = f(y[2], y[1], y[0], w)
    // Input pattern (y2 y1 y0 w) -> Y1_next
    // 0000 -> 0
    // 0001 -> 0
    // 0010 -> 1
    // 0011 -> 1
    // 0100 -> 0
    // 0101 -> 1
    // 0110 -> 0
    // 0111 -> 0
    // 1000 -> 0
    // 1001 -> 1
    // 1010 -> 1
    // 1011 -> 1

    logic y1_next;

    always @(*) begin
        case ({y, w})
            4'b0000: y1_next = 0;
            4'b0001: y1_next = 0;
            4'b0010: y1_next = 1;
            4'b0011: y1_next = 1;
            4'b0100: y1_next = 0;
            4'b0101: y1_next = 1;
            4'b0110: y1_next = 0;
            4'b0111: y1_next = 0;
            4'b1000: y1_next = 0;
            4'b1001: y1_next = 1;
            4'b1010: y1_next = 1;
            4'b1011: y1_next = 1;
            default: y1_next = 0;
        endcase
    end

    assign Y1 = y1_next;

endmodule