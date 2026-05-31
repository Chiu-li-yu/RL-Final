module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map table (cd row, ab col):
    //      ab 01 00 10 11
    // cd 00   d  0  1  1
    //    01   0  0  d  d
    //    11   0  1  1  1
    //    10   0  1  1  1

    // Mapping to inputs (c, d, a, b):
    // 0000: d -> 1
    // 0001: 0
    // 0010: 1
    // 0011: 1
    // 0100: 0
    // 0101: 0
    // 0110: d -> 1
    // 0111: d -> 1
    // 1100: 0
    // 1101: 1
    // 1110: 1
    // 1111: 1
    // 1000: 0
    // 1001: 1
    // 1010: 1
    // 1011: 1

    // Simplified Logic: 
    // out = a & (~c | ~d)
    // Testing logic:
    // When a=0: out = 0 (Correct for 0001, 0100, 0101, 1100, 1000)
    // When a=1:
    // c=0, d=0: ~0 | ~0 = 1 | 1 = 1 (1)
    // c=0, d=1: ~0 | ~1 = 1 | 0 = 1 (1)
    // c=1, d=0: ~1 | ~0 = 0 | 1 = 1 (1)
    // c=1, d=1: ~1 | ~1 = 0 | 0 = 0 (0) - Wait, this doesn't match k-map for (c=1, d=1, a=1, b=0/1) which should be 1.
    
    // Re-evaluating K-map entries for out=1:
    // (0,0,1,0), (0,0,1,1) -> c=0, d=0, a=1
    // (1,1,1,0), (1,1,1,1) -> c=1, d=1, a=1
    // (1,0,1,0), (1,0,1,1) -> c=1, d=0, a=1
    // (0,1,1,0), (0,1,1,1) -> c=0, d=1, a=1 (don't cares)
    
    // So if a=1, we want 1.
    // If a=0, we want 0 (except for some don't cares).
    // Simple logic: out = a;
    
    assign out = a;

endmodule
