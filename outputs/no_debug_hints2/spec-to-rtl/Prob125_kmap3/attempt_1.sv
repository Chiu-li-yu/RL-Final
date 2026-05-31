module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map table analysis:
    // (c,d) \ (a,b) | 00 | 01 | 10 | 11
    // ---------------------------------
    // 00            | 0  | d  | 1  | 1
    // 01            | 0  | 0  | d  | d
    // 11            | 1  | 0  | 1  | 1
    // 10            | 1  | 0  | 1  | 1
    
    // Choosing don't cares to simplify:
    // For (a,b,c,d) = (0,1,0,0) -> 0
    // For (a,b,c,d) = (1,0,1,0) -> 1
    // For (a,b,c,d) = (1,0,1,1) -> 1
    // For (a,b,c,d) = (0,1,0,1) -> 0 (already 0)
    
    // Simplified Logic: out = a | (~b & c) | (a & ~c) ... let's derive properly.
    // Let's use K-map map again:
    // Row 00 (c=0, d=0): a=0,b=0 -> 0; a=0,b=1 -> 0; a=1,b=0 -> 1; a=1,b=1 -> 1
    // Row 01 (c=0, d=1): a=0,b=0 -> 0; a=0,b=1 -> 0; a=1,b=0 -> 1; a=1,b=1 -> 1
    // Row 11 (c=1, d=1): a=0,b=0 -> 1; a=0,b=1 -> 0; a=1,b=0 -> 1; a=1,b=1 -> 1
    // Row 10 (c=1, d=0): a=0,b=0 -> 1; a=0,b=1 -> 0; a=1,b=0 -> 1; a=1,b=1 -> 1

    // Re-check truth table:
    // 0000 -> 0
    // 0001 -> 0
    // 0010 -> 1
    // 0011 -> 1
    // 0100 -> 0
    // 0101 -> 0
    // 0110 -> 0
    // 0111 -> 0
    // 1000 -> 1
    // 1001 -> 1
    // 1010 -> 1
    // 1011 -> 1
    // 1100 -> 1
    // 1101 -> 1
    // 1110 -> 1
    // 1111 -> 1

    // Logic: a | (~b & c & ~d) | (~b & c & d) -> a | (~b & c)
    // Wait, let's test:
    // a=0, b=0, c=0 -> 0 | (1 & 0) = 0
    // a=0, b=0, c=1 -> 0 | (1 & 1) = 1
    // a=0, b=1, c=0 -> 0 | (0 & 0) = 0
    // a=0, b=1, c=1 -> 0 | (0 & 1) = 0
    // a=1, b=0, c=0 -> 1 | (1 & 0) = 1
    // a=1, b=0, c=1 -> 1 | (1 & 1) = 1
    // a=1, b=1, c=0 -> 1 | (0 & 0) = 1
    // a=1, b=1, c=1 -> 1 | (0 & 1) = 1
    
    // Seems like out = a | (~b & c)
    
    assign out = a | (~b & c);
endmodule
