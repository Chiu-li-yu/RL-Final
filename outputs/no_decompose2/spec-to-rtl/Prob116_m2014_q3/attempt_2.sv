module TopModule (
    input [3:0] x,
    output logic f
);
    always @(*) begin
        // Mapping: x[3] is x[0] in 4-bit, x[4] is x[1], ... wait.
        // The spec says: input x (4 bits). Usually x[3] is MSB, x[0] is LSB.
        // The K-map labels are x[1]x[2] and x[3]x[4]. 
        // This implies index 1, 2, 3, 4. But bits are 0-3.
        // Let's assume input x[3]x[2]x[1]x[0].
        // x[1]x[2] in K-map is x[2]x[1] in bit indexing.
        // x[3]x[4] in K-map is x[3]x[0] in bit indexing.
        
        // Truth Table re-evaluation:
        // x[3] x[2] x[1] x[0] -> K-map row: x[3]x[0], col: x[2]x[1]
        // K-map:
        // row col | val
        // 00 00 | d -> 0
        // 00 01 | 0 -> 0
        // 00 11 | d -> 0
        // 00 10 | d -> 0
        // 01 00 | 0 -> 0
        // 01 01 | d -> 1
        // 01 11 | 1 -> 1
        // 01 10 | 0 -> 0
        // 11 00 | 1 -> 1
        // 11 01 | 1 -> 1
        // 11 11 | d -> 0
        // 11 10 | d -> 0
        // 10 00 | 1 -> 1
        // 10 01 | 1 -> 1
        // 10 11 | 0 -> 0
        // 10 10 | d -> 0

        // Let's use case statement based on x
        case (x)
            4'b0101: f = 1;
            4'b0111: f = 1;
            4'b1100: f = 1;
            4'b1101: f = 1;
            4'b1000: f = 1;
            4'b1001: f = 1;
            default: f = 0;
        endcase
    end
endmodule
