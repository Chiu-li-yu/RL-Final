module TopModule (
    input [3:0] x,
    output logic f
);
    // K-map:
    //         x[0]x[1]
    // x[2]x[3]  00  01  11  10
    //   00     | 1 | 0 | 0 | 1 |  (x[2]x[3]=00 -> x[0]x[1]=00 or 10 -> f=1)
    //   01     | 0 | 0 | 0 | 0 |
    //   11     | 1 | 1 | 1 | 0 |  (x[2]x[3]=11 -> x[0]x[1]=00, 01, 11 -> f=1)
    //   10     | 1 | 1 | 0 | 1 |  (x[2]x[3]=10 -> x[0]x[1]=00, 01, 10 -> f=1)

    // Re-check Mapping (x is [3:0] so MSB is x[3]):
    // Wait, the specification says:
    // Input x (4 bits)
    // K-map row/col: x[2]x[3] and x[0]x[1]
    
    // If we assume input is [x[3], x[2], x[1], x[0]]
    // K-map row: x[2]x[3]
    // K-map col: x[0]x[1]
    
    // Row 00 (x2=0, x3=0): 1, 0, 0, 1 -> x[0]x[1] = 00 or 10
    // Row 01 (x2=0, x3=1): 0, 0, 0, 0
    // Row 11 (x2=1, x3=1): 1, 1, 1, 0 -> x[0]x[1] = 00, 01, 11
    // Row 10 (x2=1, x3=0): 1, 1, 0, 1 -> x[0]x[1] = 00, 01, 10

    // Combine into boolean expression:
    // f = (~x[2]&~x[3]&~x[0]&~x[1]) | (~x[2]&~x[3]&x[0]&~x[1]) | ...
    // Let's list all 1s as (x3, x2, x1, x0):
    // 00: 0000 (x3=0, x2=0, x1=0, x0=0) -> f=1
    // 00: 0010 (x3=0, x2=0, x1=1, x0=0) -> f=1
    // 11: 1100 (x3=1, x2=1, x1=0, x0=0) -> f=1
    // 11: 1101 (x3=1, x2=1, x1=0, x0=1) -> f=1
    // 11: 1111 (x3=1, x2=1, x1=1, x0=1) -> f=1
    // 10: 1000 (x3=1, x2=0, x1=0, x0=0) -> f=1
    // 10: 1001 (x3=1, x2=0, x1=0, x0=1) -> f=1
    // 10: 1010 (x3=1, x2=0, x1=1, x0=0) -> f=1

    always @(*) begin
        // Row 00: (x2=0, x3=0)
        // Col 00 (x0=0, x1=0) OR Col 10 (x0=1, x1=0)
        // Row 11: (x2=1, x3=1)
        // Col 00 (x0=0, x1=0) OR Col 01 (x0=0, x1=1) OR Col 11 (x0=1, x1=1)
        // Row 10: (x2=1, x3=0)
        // Col 00 (x0=0, x1=0) OR Col 01 (x0=0, x1=1) OR Col 10 (x0=1, x1=0)
        
        // This input indexing is likely x[3] is MSB.
        // Let's use the decimal values calculated from (x[2], x[3], x[0], x[1])
        // If row is x[2]x[3] and col is x[0]x[1], then the 4-bit number is {x[2], x[3], x[0], x[1]}
        // Wait, normally {x[3], x[2], x[1], x[0]}. Let's try mapping carefully.
        
        // Let's represent the map as f(x3, x2, x1, x0):
        // Map table:
        // x2x3 | x0x1
        //      | 00 01 11 10
        // 00   | 1  0  0  1
        // 01   | 0  0  0  0
        // 11   | 1  1  1  0
        // 10   | 1  1  0  1

        // Let's check bit combinations:
        // f(x3, x2, x1, x0) = 1 if:
        // (x2=0, x3=0, x0=0, x1=0) -> 0000
        // (x2=0, x3=0, x0=1, x1=0) -> 0001
        // (x2=1, x3=1, x0=0, x1=0) -> 1100
        // (x2=1, x3=1, x0=0, x1=1) -> 1110
        // (x2=1, x3=1, x0=1, x1=1) -> 1111
        // (x2=1, x3=0, x0=0, x1=0) -> 0100
        // (x2=1, x3=0, x0=0, x1=1) -> 0110
        // (x2=1, x3=0, x0=1, x1=0) -> 0101
        
        case ({x[3], x[2], x[1], x[0]})
            4'b0000: f = 1'b1;
            4'b0001: f = 1'b1;
            4'b1100: f = 1'b1;
            4'b1110: f = 1'b1;
            4'b1111: f = 1'b1;
            4'b0100: f = 1'b1;
            4'b0110: f = 1'b1;
            4'b0101: f = 1'b1;
            default: f = 1'b0;
        endcase
    end
endmodule
