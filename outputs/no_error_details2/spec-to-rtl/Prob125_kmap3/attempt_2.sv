module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);

    // Re-evaluating K-Map from provided table:
    //    ab
    // cd 00 01 10 11
    // 00  d  0  1  1
    // 01  0  0  d  d
    // 11  0  1  1  1
    // 10  0  1  1  1
    
    // c=0, d=0: ab=00:d, 01:0, 10:1, 11:1
    // c=0, d=1: ab=00:0, 01:0, 10:d, 11:d
    // c=1, d=1: ab=00:0, 01:1, 10:1, 11:1
    // c=1, d=0: ab=00:0, 01:1, 10:1, 11:1

    // Truth Table:
    // a b c d | out
    // 0 0 0 0 | d(0) -> 0
    // 0 0 0 1 | 0
    // 0 0 1 0 | 0
    // 0 0 1 1 | 0
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | 1
    // 0 1 1 1 | 1
    // 1 0 0 0 | 1
    // 1 0 0 1 | d(1) -> 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 1
    // 1 1 0 1 | d(1) -> 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1

    // Logic for out:
    // Out = 1 if:
    // (a=1) OR (b=1 AND c=1)
    
    // Let's re-verify the input order in the map description:
    // The columns are 'ab' (00, 01, 10, 11)
    // The rows are 'cd' (00, 01, 11, 10) - Gray code order
    
    // Let's re-parse strictly:
    // col 00: (c=0, d=0):0, (c=0, d=1):0, (c=1, d=1):0, (c=1, d=0):0 -> all 0
    // col 01: (c=0, d=0):0, (c=0, d=1):0, (c=1, d=1):1, (c=1, d=0):1 -> 1 if c=1
    // col 10: (c=0, d=0):1, (c=0, d=1):d, (c=1, d=1):1, (c=1, d=0):1 -> 1
    // col 11: (c=0, d=0):1, (c=0, d=1):d, (c=1, d=1):1, (c=1, d=0):1 -> 1
    
    // Simplified logic:
    // out = a | (b & c)
    // Let's check:
    // c=0, d=0, ab=10 -> a=1, b=0, c=0. out = 1 | (0 & 0) = 1. (Correct)
    // c=0, d=0, ab=00 -> a=0, b=0, c=0. out = 0 | (0 & 0) = 0. (Correct)
    
    // Wait, the K-map provided was:
    //               ab
    //    cd   00  01  10  11
    //    00 | d | 0 | 1 | 1 |
    //    01 | 0 | 0 | d | d |
    //    11 | 0 | 1 | 1 | 1 |
    //    10 | 0 | 1 | 1 | 1 |
    
    // (My previous read was transposed?)
    // Let's re-read columns: 
    // row 00 (c=0, d=0): ab=00:d, 01:0, 10:1, 11:1
    // row 01 (c=0, d=1): ab=00:0, 01:0, 10:d, 11:d
    // row 11 (c=1, d=1): ab=00:0, 01:1, 10:1, 11:1
    // row 10 (c=1, d=0): ab=00:0, 01:1, 10:1, 11:1
    
    // Truth table:
    // a b c d | out
    // 0 0 0 0 | d(0) -> 0
    // 0 1 0 0 | 0
    // 1 0 0 0 | 1
    // 1 1 0 0 | 1
    // 0 0 0 1 | 0
    // 0 1 0 1 | 0
    // 1 0 0 1 | d(1) -> 1
    // 1 1 0 1 | d(1) -> 1
    // 0 0 1 1 | 0
    // 0 1 1 1 | 1
    // 1 0 1 1 | 1
    // 1 1 1 1 | 1
    // 0 0 1 0 | 0
    // 0 1 1 0 | 1
    // 1 0 1 0 | 1
    // 1 1 1 0 | 1
    
    // out = a | (b & c) | (b & ~d) ? No.
    // Looking at rows:
    // If a=1: out=1
    // If a=0: 
    //   if b=0: out=0
    //   if b=1: out=1 if (c=1 or d=0) -> 1 if (c=1 or ~d=1)
    
    // So out = a | (b & (c | ~d))
    
    always @(*) begin
        out = a | (b & (c | ~d));
    end

endmodule