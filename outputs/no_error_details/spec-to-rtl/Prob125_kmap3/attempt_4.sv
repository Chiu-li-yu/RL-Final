module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);
    // Based on K-map:
    //      ab
    // cd   01  00  10  11
    // 00 | d | 0 | 1 | 1 |
    // 01 | 0 | 0 | d | d |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 0 | 1 | 1 | 1 |

    // Let's map minterms (m) and don't cares (d)
    // Variables: c, d, a, b (binary order)
    // Table indices: (c,d,a,b)
    // 0000 (0,0,0,0) = 0
    // 0001 (0,0,0,1) = d
    // 0010 (0,0,1,0) = 1
    // 0011 (0,0,1,1) = 1
    // 0100 (0,1,0,0) = 0
    // 0101 (0,1,0,1) = 0
    // 0110 (0,1,1,0) = d
    // 0111 (0,1,1,1) = d
    // 1000 (1,0,0,0) = 0
    // 1001 (1,0,0,1) = 1
    // 1010 (1,0,1,0) = 1
    // 1011 (1,0,1,1) = 1
    // 1100 (1,1,0,0) = 0
    // 1101 (1,1,0,1) = 0
    // 1110 (1,1,1,0) = 1
    // 1111 (1,1,1,1) = 1

    // Re-evaluating based on column labels:
    // Columns (ab): 01, 00, 10, 11
    // Row 00 (c=0, d=0): Col 01=d, 00=0, 10=1, 11=1
    // Row 01 (c=0, d=1): Col 01=0, 00=0, 10=d, 11=d
    // Row 11 (c=1, d=1): Col 01=0, 00=1, 10=1, 11=1
    // Row 10 (c=1, d=0): Col 01=0, 00=1, 10=1, 11=1

    // Filling table correctly:
    // (a,b,c,d)
    // c=0, d=0: (0,1,0,0)=d, (0,0,0,0)=0, (1,0,0,0)=1, (1,1,0,0)=1
    // c=0, d=1: (0,1,0,1)=0, (0,0,0,1)=0, (1,0,0,1)=d, (1,1,0,1)=d
    // c=1, d=1: (0,1,1,1)=0, (0,0,1,1)=1, (1,0,1,1)=1, (1,1,1,1)=1
    // c=1, d=0: (0,1,1,0)=0, (0,0,1,0)=1, (1,0,1,0)=1, (1,1,1,0)=1

    // Simplified Logic: 
    // out = a | (c & ~b) | (~c & ~d & a) ... 
    // Let's use a Karnaugh solver approach:
    // F = a | (c & ~b) is not quite right.
    // Let's try: a | (c & ~b) | (~c & ~d & a)
    
    always @(*) begin
        out = a | (c & ~b) | (~c & ~d & ~b);
    end
endmodule