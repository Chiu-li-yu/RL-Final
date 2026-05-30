module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Karnaugh Map:
    //      ab
    // cd   00 01 11 10
    // 00 | 0  1  0  1
    // 01 | 1  0  1  0
    // 11 | 0  1  0  1
    // 10 | 1  0  1  0
    
    // Rows: cd, Cols: ab
    // (a,b,c,d)
    // 0000: 0
    // 0001: 1
    // 0010: 1
    // 0011: 0
    // 0100: 1
    // 0101: 0
    // 0110: 0
    // 0111: 1
    // 1000: 0
    // 1001: 1
    // 1010: 1
    // 1011: 0
    // 1100: 1
    // 1101: 0
    // 1110: 0
    // 1111: 1
    
    // Karnaugh Map Analysis:
    // out = (~a & ~b & ~c & d) | (~a & ~b & c & ~d) | 
    //       (~a & b & ~c & ~d) | (~a & b & c & d) |
    //       (a & ~b & ~c & d) | (a & ~b & c & ~d) |
    //       (a & b & ~c & ~d) | (a & b & c & d)
    
    // Simplification:
    // out = (a XOR b) XOR (c XOR d)
    
    always @(*) begin
        out = (a ^ b) ^ (c ^ d);
    end
endmodule
