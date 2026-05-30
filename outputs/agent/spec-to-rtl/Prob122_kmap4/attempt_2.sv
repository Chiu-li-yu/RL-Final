module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out
);
    // Analysis of K-map provided:
    //      ab
    // cd   00 01 11 10
    // 00 | 0 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 1 | 0 |
    // 11 | 0 | 1 | 0 | 1 |
    // 10 | 1 | 0 | 1 | 0 |

    // Let's verify the pattern:
    // (a,b,c,d)
    // 0000 -> 0
    // 0001 -> 1
    // 0010 -> 1
    // 0011 -> 0
    // 0100 -> 1
    // 0101 -> 0
    // 0110 -> 0
    // 0111 -> 1
    // 1000 -> 0
    // 1001 -> 1
    // 1010 -> 1
    // 1011 -> 0
    // 1100 -> 1
    // 1101 -> 0
    // 1110 -> 0
    // 1111 -> 1

    // It looks like out = a ^ b ^ c ^ d
    
    always @(*) begin
        out = a ^ b ^ c ^ d;
    end
endmodule
