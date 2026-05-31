module TopModule (
    input [3:0] x,
    output f
);
    // Re-check Karnaugh Map:
    // x[2]x[3]  x[0]x[1]
    //           00  01  11  10
    //     00  | 1 | 0 | 0 | 1 |
    //     01  | 0 | 0 | 0 | 0 |
    //     11  | 1 | 1 | 1 | 0 |
    //     10  | 1 | 1 | 0 | 1 |

    // Map columns are (x[0], x[1]) -> 00, 01, 11, 10
    // Map rows are (x[2], x[3]) -> 00, 01, 11, 10

    // x[3]x[2]  x[1]x[0] (Careful: Map labels are x[2]x[3] and x[0]x[1])
    // So Row is {x[2], x[3]}, Column is {x[0], x[1]}

    // Let's list the 1s precisely:
    // Row 00, Col 00: x[2]=0, x[3]=0, x[0]=0, x[1]=0 -> x=0000 -> f=1
    // Row 00, Col 10: x[2]=0, x[3]=0, x[0]=1, x[1]=0 -> x=0001 -> f=1
    // Row 11, Col 00: x[2]=1, x[3]=1, x[0]=0, x[1]=0 -> x=1100 -> f=1
    // Row 11, Col 01: x[2]=1, x[3]=1, x[0]=0, x[1]=1 -> x=1110 -> f=1
    // Row 11, Col 11: x[2]=1, x[3]=1, x[0]=1, x[1]=1 -> x=1111 -> f=1
    // Row 10, Col 00: x[2]=1, x[3]=0, x[0]=0, x[1]=0 -> x=0100 -> f=1
    // Row 10, Col 01: x[2]=1, x[3]=0, x[0]=0, x[1]=1 -> x=0110 -> f=1
    // Row 10, Col 10: x[2]=1, x[3]=0, x[0]=1, x[0]=0 -> x=0101 -> f=1

    // Re-calculating with explicit bit mapping based on (Row, Col):
    // Row is {x[2], x[3]}
    // Col is {x[0], x[1]}
    // The bit string is {x[3], x[2], x[1], x[0]}
    
    // 1s at:
    // Row=00, Col=00: x3=0, x2=0, x1=0, x0=0 -> 4'b0000
    // Row=00, Col=10: x3=0, x2=0, x1=0, x0=1 -> 4'b0001
    // Row=11, Col=00: x3=1, x2=1, x1=0, x0=0 -> 4'b1100
    // Row=11, Col=01: x3=1, x2=1, x1=1, x0=0 -> 4'b1110
    // Row=11, Col=11: x3=1, x2=1, x1=1, x0=1 -> 4'b1111
    // Row=10, Col=00: x3=0, x2=1, x1=0, x0=0 -> 4'b0100
    // Row=10, Col=01: x3=0, x2=1, x1=1, x0=0 -> 4'b0110
    // Row=10, Col=10: x3=0, x2=1, x1=0, x0=1 -> 4'b0101

    logic f_val;
    always @(*) begin
        case({x[3], x[2], x[1], x[0]})
            4'b0000: f_val = 1;
            4'b0001: f_val = 1;
            4'b1100: f_val = 1;
            4'b1110: f_val = 1;
            4'b1111: f_val = 1;
            4'b0100: f_val = 1;
            4'b0110: f_val = 1;
            4'b0101: f_val = 1;
            default: f_val = 0;
        endcase
    end
    assign f = f_val;
endmodule
