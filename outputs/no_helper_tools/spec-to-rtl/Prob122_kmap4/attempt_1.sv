module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    always @(*) begin
        // Mapping the K-map:
        //      ab
        // cd 00 01 11 10
        // 00  0  1  0  1
        // 01  1  0  1  0
        // 11  0  1  0  1
        // 10  1  0  1  0
        
        // Let's identify the 1s:
        // (a,b,c,d) = (0,1,0,0) -> 4
        // (a,b,c,d) = (1,0,0,0) -> 8
        // (a,b,c,d) = (0,0,0,1) -> 1
        // (a,b,c,d) = (1,1,0,1) -> 13
        // (a,b,c,d) = (0,1,1,1) -> 7
        // (a,b,c,d) = (1,0,1,1) -> 11
        // (a,b,c,d) = (0,0,1,0) -> 2
        // (a,b,c,d) = (1,1,1,0) -> 14
        
        // This is XOR(a, b, c, d)
        // Check:
        // 0000: 0
        // 0001: 1 (True)
        // 0010: 1 (True)
        // 0011: 0 (True)
        // 0100: 1 (True)
        // 0101: 0 (True)
        // 0110: 0 (True)
        // 0111: 1 (True)
        // 1000: 1 (True)
        // 1001: 0 (True)
        // 1010: 0 (True)
        // 1011: 1 (True)
        // 1100: 0 (True)
        // 1101: 1 (True)
        // 1110: 1 (True)
        // 1111: 0 (True)
        
        // Yes, it is XOR(a, b, c, d)
        // Wait, re-checking K-map:
        // K-map table columns: 00, 01, 11, 10
        // Input: cd=00, ab=01 -> out=1. (a,b,c,d) = (0,1,0,0)
        // Input: cd=00, ab=10 -> out=1. (a,b,c,d) = (1,0,0,0)
        // Input: cd=01, ab=00 -> out=1. (a,b,c,d) = (0,0,0,1)
        // Input: cd=01, ab=11 -> out=1. (a,b,c,d) = (1,1,0,1)
        // Input: cd=11, ab=01 -> out=1. (a,b,c,d) = (0,1,1,1)
        // Input: cd=11, ab=10 -> out=1. (a,b,c,d) = (1,0,1,1)
        // Input: cd=10, ab=00 -> out=1. (a,b,c,d) = (0,0,1,0)
        // Input: cd=10, ab=11 -> out=1. (a,b,c,d) = (1,1,1,0)
        
        // The parity is odd: a^b^c^d
        out = a ^ b ^ c ^ d;
    end
endmodule