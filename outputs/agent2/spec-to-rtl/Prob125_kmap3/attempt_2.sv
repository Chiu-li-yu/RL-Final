module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output logic out
);
    always @(*) begin
        // K-map (c,d) vs (a,b)
        // Table:
        //    ab | 01 | 00 | 10 | 11
        // cd ---------------------
        // 00    |  d |  0 |  1 |  1
        // 01    |  0 |  0 |  d |  d
        // 11    |  0 |  1 |  1 |  1
        // 10    |  0 |  1 |  1 |  1
        
        // Re-mapping (c,d,a,b):
        // 0000: 0
        // 0001: d -> 0
        // 0010: 1
        // 0011: 1
        // 0100: 0
        // 0101: 0
        // 0110: d -> 1
        // 0111: d -> 1
        // 1100: 1
        // 1101: 0
        // 1110: 1
        // 1111: 1
        // 1000: 1
        // 1001: 0
        // 1010: 1
        // 1011: 1
        
        // Logic: out = a | (c & ~b) | (d & ~b)
        // Checking:
        // 0000 -> 0 | 0 = 0 (OK)
        // 0001 -> 0 | 0 = 0 (OK)
        // 0010 -> 1 | 0 = 1 (OK)
        // 0011 -> 1 | 0 = 1 (OK)
        // 0100 -> 0 | 0 | 1 = 1 (Wait, table says 0)
        
        // Let's try: out = a | (c & ~b & ~d) | (~c & ~d & a) ... this is hard.
        // Let's use SOP:
        // out = (a & ~b & ~c & ~d) | (a & ~b & ~c & d) | (a & ~b & c & ~d) | (a & ~b & c & d) |
        //       (a & b & ~c & ~d) | (a & b & ~c & d) | (a & b & c & ~d) | (a & b & c & d) |
        //       (~a & ~b & c & ~d) | (~a & ~b & c & d) |
        //       (~a & ~b & ~c & ~d) ... no, row 00 col 00 is 0.
        
        // Let's use: out = a | (c & ~b)
        // Re-check:
        // (c,d,a,b) = (1,1,0,0) -> 1 | (1 & 1) = 1 (OK)
        // (c,d,a,b) = (1,0,0,0) -> 1 | (1 & 1) = 1 (OK)
        // (c,d,a,b) = (0,0,0,0) -> 0 | (0 & 1) = 0 (OK)
        // (c,d,a,b) = (0,1,0,0) -> 0 | (0 & 1) = 0 (OK)
        // Seems correct!
        out = a | (c & ~b);
    end
endmodule