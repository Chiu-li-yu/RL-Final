module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Let's re-map strictly to the table provided in the prompt:
    // The table header is "ab" horizontally and "cd" vertically.
    //            ab
    // cd    00  01  11  10
    // 00 | 0 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 1 | 0 |
    // 11 | 0 | 1 | 0 | 1 |
    // 10 | 1 | 0 | 1 | 0 |
    
    // Rows (cd):
    // 00 (c=0,d=0)
    // 01 (c=0,d=1)
    // 11 (c=1,d=1)
    // 10 (c=1,d=0)
    
    // Cols (ab):
    // 00 (a=0,b=0)
    // 01 (a=0,b=1)
    // 11 (a=1,b=1)
    // 10 (a=1,b=0)
    
    // Let's write the table as (c,d,a,b) = out:
    // (0,0,0,0) = 0
    // (0,0,0,1) = 1
    // (0,0,1,1) = 0
    // (0,0,1,0) = 1
    // (0,1,0,0) = 1
    // (0,1,0,1) = 0
    // (0,1,1,1) = 1
    // (0,1,1,0) = 0
    // (1,1,0,0) = 0
    // (1,1,0,1) = 1
    // (1,1,1,1) = 0
    // (1,1,1,0) = 1
    // (1,0,0,0) = 1
    // (1,0,0,1) = 0
    // (1,0,1,1) = 1
    // (1,0,1,0) = 0
    
    // Wait, the rows are cd = 00, 01, 11, 10
    // So row 11 is (c=1, d=1). Row 10 is (c=1, d=0).
    
    // Let's re-evaluate the pattern:
    // If we look at (b, d)
    // b,d | Row/Col values
    // 0,0 -> 0 (for cd=00, ab=00), 0 (for cd=00, ab=11), 1 (for cd=01, ab=01), 1 (for cd=01, ab=10)... this is not just b ^ d.
    
    // Let's take every case where out = 1:
    // (c,d,a,b)
    // 0001: 1
    // 0010: 1
    // 0100: 1
    // 0111: 1
    // 1101: 1
    // 1110: 1
    // 1000: 1
    // 1011: 1
    
    // Logic:
    // 0001: ~c & ~d & ~a & b
    // 0010: ~c & ~d & a & ~b
    // 0100: ~c & d & ~a & ~b
    // 0111: ~c & d & a & b
    // 1101: c & d & ~a & b
    // 1110: c & d & a & ~b
    // 1000: c & ~d & ~a & ~b
    // 1011: c & ~d & a & b
    
    // This looks like (a ^ b ^ c ^ d). Let's test:
    // a^b^c^d
    // 0001 -> 1
    // 0010 -> 1
    // 0100 -> 1
    // 0111 -> 1
    // 1101 -> 1
    // 1110 -> 1
    // 1000 -> 1
    // 1011 -> 1
    // Yes! It is a ^ b ^ c ^ d.

    assign out = a ^ b ^ c ^ d;
endmodule
