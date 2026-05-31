module TopModule (
    input [3:0] x,
    output logic f
);
    // x = {x[3], x[2], x[1], x[0]} 
    // Wait, the specification says:
    // x (4 bits), referring to x[0], x[1], x[2], x[3] as bits.
    // The K-map shows rows as "x[2]x[3]" and cols as "x[0]x[1]".
    // This usually means bits are concatenated as x[2] concatenated with x[3], 
    // so row index is {x[2], x[3]} and col index is {x[0], x[1]}.

    always @(*) begin
        // K-map table (row {x2,x3}, col {x0,x1}):
        //       00  01  11  10
        // 00 | 1 | 0 | 0 | 1 |
        // 01 | 0 | 0 | 0 | 0 |
        // 11 | 1 | 1 | 1 | 0 |
        // 10 | 1 | 1 | 0 | 1 |

        // Input x is {x[3], x[2], x[1], x[0]}? No, "x (4 bits)".
        // It's standard to map {x[3], x[2], x[1], x[0]}.
        // Let's assume input vector x is {x[3], x[2], x[1], x[0]}.
        
        case ({x[2], x[3], x[0], x[1]})
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
