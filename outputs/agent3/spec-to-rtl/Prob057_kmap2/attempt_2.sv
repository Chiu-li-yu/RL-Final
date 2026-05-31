module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Re-mapping the K-map inputs (columns ab, rows cd)
    // Map index:
    //      ab=00 ab=01 ab=11 ab=10
    // cd=00 | 1 | 1 | 0 | 1 |
    // cd=01 | 1 | 0 | 0 | 1 |
    // cd=11 | 0 | 1 | 1 | 1 |
    // cd=10 | 1 | 1 | 0 | 0 |

    // Let's identify the 1s by (a, b, c, d):
    // (a,b,c,d)
    // (0,0,0,0) -> 1
    // (0,1,0,0) -> 1
    // (1,1,0,0) -> 0
    // (1,0,0,0) -> 1
    
    // (0,0,0,1) -> 1
    // (0,1,0,1) -> 0
    // (1,1,0,1) -> 0
    // (1,0,0,1) -> 1
    
    // (0,0,1,1) -> 0
    // (0,1,1,1) -> 1
    // (1,1,1,1) -> 1
    // (1,0,1,1) -> 1
    
    // (0,0,1,0) -> 1
    // (0,1,1,0) -> 1
    // (1,1,1,0) -> 0
    // (1,0,1,0) -> 0

    // Re-verifying Truth Table (a, b, c, d):
    // a b c d | out
    // 0 0 0 0 | 1
    // 0 0 0 1 | 1
    // 0 0 1 0 | 1
    // 0 0 1 1 | 0
    // 0 1 0 0 | 1
    // 0 1 0 1 | 0
    // 0 1 1 0 | 1
    // 0 1 1 1 | 1
    // 1 0 0 0 | 1
    // 1 0 0 1 | 1
    // 1 0 1 0 | 0
    // 1 0 1 1 | 1
    // 1 1 0 0 | 0
    // 1 1 0 1 | 0
    // 1 1 1 0 | 0
    // 1 1 1 1 | 1

    logic out_temp;
    always @(*) begin
        case ({a, b, c, d})
            4'b0000: out_temp = 1;
            4'b0001: out_temp = 1;
            4'b0010: out_temp = 1;
            4'b0011: out_temp = 0;
            4'b0100: out_temp = 1;
            4'b0101: out_temp = 0;
            4'b0110: out_temp = 1;
            4'b0111: out_temp = 1;
            4'b1000: out_temp = 1;
            4'b1001: out_temp = 1;
            4'b1010: out_temp = 0;
            4'b1011: out_temp = 1;
            4'b1100: out_temp = 0;
            4'b1101: out_temp = 0;
            4'b1110: out_temp = 0;
            4'b1111: out_temp = 1;
        endcase
    end
    assign out = out_temp;

endmodule
