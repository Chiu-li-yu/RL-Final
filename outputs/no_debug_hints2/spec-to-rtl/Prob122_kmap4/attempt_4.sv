module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out
);

    // Re-evaluating K-map again
    //      ab: 00  01  11  10
    // cd=00 | 0 | 1 | 0 | 1 |
    // cd=01 | 1 | 0 | 1 | 0 |
    // cd=11 | 0 | 1 | 0 | 1 |
    // cd=10 | 1 | 0 | 1 | 0 |

    // Map:
    // (ab, cd)
    // 00, 00 -> 0
    // 00, 01 -> 1
    // 00, 11 -> 0
    // 00, 10 -> 1
    // 01, 00 -> 1
    // 01, 01 -> 0
    // 01, 11 -> 1
    // 01, 10 -> 0
    // 11, 00 -> 0
    // 11, 01 -> 1
    // 11, 11 -> 0
    // 11, 10 -> 1
    // 10, 00 -> 1
    // 10, 01 -> 0
    // 10, 11 -> 1
    // 10, 10 -> 0

    // Compare with (c ^ d)
    // cd=00, c^d=0. Map: 0, 1, 0, 1.
    // cd=01, c^d=1. Map: 1, 0, 1, 0.
    // cd=11, c^d=0. Map: 0, 1, 0, 1.
    // cd=10, c^d=1. Map: 1, 0, 1, 0.

    // Let's see:
    // When c^d = 0: out is 0 at ab=00, 11. out is 1 at ab=01, 10.
    // When c^d = 1: out is 1 at ab=00, 11. out is 0 at ab=01, 10.
    
    // (c^d) XORed with (a^b)?
    // (a^b) at (00, 01, 11, 10) -> (0, 1, 0, 1)
    
    // If c^d=0, we need 0 at (a^b)=0 and 1 at (a^b)=1. This is (a^b).
    // If c^d=1, we need 1 at (a^b)=0 and 0 at (a^b)=1. This is !(a^b).
    
    // So out = (a ^ b) ^ (c ^ d)
    
    always @(*) begin
        out = (a ^ b) ^ (c ^ d);
    end

endmodule
