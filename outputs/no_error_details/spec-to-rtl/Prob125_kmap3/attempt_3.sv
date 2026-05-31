module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);
    // Table:
    //      ab
    // cd   01  00  10  11
    // 00 | d | 0 | 1 | 1 |
    // 01 | 0 | 0 | d | d |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 0 | 1 | 1 | 1 |

    // Let's list the combinations where out = 1 (treating d as 0 or 1):
    // Table indices [c,d,a,b]
    // 0,0,0,1: 1 (if d=1)
    // 0,0,0,0: 0
    // 0,0,1,0: 1
    // 0,0,1,1: 1
    // 0,1,0,1: 0
    // 0,1,0,0: 0
    // 0,1,1,0: 1 (if d=1)
    // 0,1,1,1: 1 (if d=1)
    // 1,1,0,1: 0
    // 1,1,0,0: 1
    // 1,1,1,0: 1
    // 1,1,1,1: 1
    // 1,0,0,1: 0
    // 1,0,0,0: 1
    // 1,0,1,0: 1
    // 1,0,1,1: 1

    // Standard sum of products covering all 1s:
    // When d is a don't care, we can set it to 1 if it helps simplify.
    // Setting all d=1:
    // 0,0,0,1 (d=1)
    // 0,0,1,0 (1)
    // 0,0,1,1 (1)
    // 0,1,1,0 (d=1)
    // 0,1,1,1 (d=1)
    // 1,1,0,0 (1)
    // 1,1,1,0 (1)
    // 1,1,1,1 (1)
    // 1,0,0,0 (1)
    // 1,0,1,0 (1)
    // 1,0,1,1 (1)

    // Simplified Boolean: a | (b & ~c)
    // Let's check:
    // a=1 -> out=1 (covers (0,0,1,0), (0,0,1,1), (1,1,1,0), (1,1,1,1), (1,0,1,0), (1,0,1,1))
    // a=0, b=1, c=0 -> (0,0,0,1) -> 1
    // a=0, b=1, c=1 -> (1,1,0,1) -> 0
    // a=0, b=0, c=1 -> (1,0,0,0) -> 1
    // a=0, b=1, c=0 -> (0,1,0,1)? Wait.
    
    // Let's re-verify:
    // Row 00: b=1(01) -> d, b=0(00) -> 0, b=2(10) -> 1, b=3(11) -> 1
    // Row 01: b=1(01) -> 0, b=0(00) -> 0, b=2(10) -> d, b=3(11) -> d
    // Row 11: b=1(01) -> 0, b=0(00) -> 1, b=2(10) -> 1, b=3(11) -> 1
    // Row 10: b=1(01) -> 0, b=0(00) -> 1, b=2(10) -> 1, b=3(11) -> 1

    always @(*) begin
        out = a | (~c & b) | (~d & ~c & b); // Just try a simpler expression first
    end
endmodule