module TopModule (
    input [3:0] x,
    output logic f
);

    // K-map:
    // x[2]x[3] \ x[0]x[1] | 00 | 01 | 11 | 10 |
    // --------------------+----+----+----+----+
    // 00                  | 1  | 0  | 0  | 1  |
    // 01                  | 0  | 0  | 0  | 0  |
    // 11                  | 1  | 1  | 1  | 0  |
    // 10                  | 1  | 1  | 0  | 1  |
    //
    // Minimized logic:
    // Minterms:
    // 0000 (m0), 0010 (m2)
    // 1100 (m12), 1101 (m13), 1111 (m15)
    // 1000 (m8), 1001 (m9), 1010 (m10)
    //
    // Let's use Sum of Products or simplified logic:
    // f = (~x[2] & ~x[3] & ~x[1]) | 
    //     (x[2] & x[3] & ~x[1]) |
    //     (x[2] & ~x[3] & ~x[1]) | 
    //     (x[2] & ~x[3] & ~x[0]) |
    //     (x[2] & x[3] & ~x[0])

    always @(*) begin
        case (x)
            4'b0000: f = 1'b1;
            4'b0010: f = 1'b1;
            4'b1100: f = 1'b1;
            4'b1101: f = 1'b1;
            4'b1111: f = 1'b1;
            4'b1000: f = 1'b1;
            4'b1001: f = 1'b1;
            4'b1010: f = 1'b1;
            default: f = 1'b0;
        endcase
    end
endmodule
