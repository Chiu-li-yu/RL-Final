module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);
    // Table again:
    //      ab
    // cd   01  00  10  11
    // 00 | d | 0 | 1 | 1 |
    // 01 | 0 | 0 | d | d |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 0 | 1 | 1 | 1 |

    // Let's use truth table values (d=0) for calculation:
    // a b c d | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | 0
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | 0
    // 0 1 1 1 | 0
    // 1 0 0 0 | 1
    // 1 0 0 1 | 0
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 1
    // 1 1 0 1 | 0
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1

    always @(*) begin
        // Based on logic above: 
        // out = (c & ~b & ~d) | (c & ~b & d) | (~c & a & ~b) | (~c & a & b) | (a & c & ~d) | (a & c & d)
        // This simplifies to (c & ~b) | (a & c) | (a & ~c & ~d)
        out = (c & ~b) | (a & c) | (a & ~c & ~d);
    end
endmodule