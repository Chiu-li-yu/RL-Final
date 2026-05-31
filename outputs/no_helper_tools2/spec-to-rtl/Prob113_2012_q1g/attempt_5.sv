module TopModule (
    input [3:0] x,
    output logic f
);
    // Let's re-interpret: "x[0]x[1]" on top, "x[2]x[3]" on side.
    // The columns are 00, 01, 11, 10.
    // The rows are 00, 01, 11, 10.
    
    // Maybe x = {x[0], x[1], x[2], x[3]} ?
    // No, input is "x (4 bits)".
    
    // Let's re-read the K-map:
    //      x[0]x[1]
    // x[2]x[3]  00  01  11  10
    //   00     | 1 | 0 | 0 | 1 |
    //   01     | 0 | 0 | 0 | 0 |
    //   11     | 1 | 1 | 1 | 0 |
    //   10     | 1 | 1 | 0 | 1 |

    // If input x is defined as {x[0], x[1], x[2], x[3]} (order-wise):
    // x[0] corresponds to MSB?
    // Let's assume standard index: x[0] is MSB, x[3] is LSB?
    // No, usually x[0] is LSB.
    // Let's assume input order is {x[2], x[3], x[0], x[1]} = {MSB...LSB}
    
    // What if the table is:
    // Rows (x2x3) -> x[3], x[2]
    // Cols (x0x1) -> x[1], x[0]
    
    // Let's try every permutation of mapping x[0], x[1], x[2], x[3] to the map.
    // There are 24 permutations. But usually, it's either {x[3], x[2], x[1], x[0]} or {x[0], x[1], x[2], x[3]}.
    
    // Let's try x = {x[3], x[2], x[1], x[0]}
    // Row = {x[3], x[2]}, Col = {x[1], x[0]}
    // Row 00 (0,0), Col 00 (0,0) -> f=1
    // Row 00 (0,0), Col 01 (0,1) -> f=0
    // Row 00 (0,0), Col 11 (1,1) -> f=0
    // Row 00 (0,0), Col 10 (1,0) -> f=1
    // ...
    // This is what I did first.
    
    // Maybe the K-map is x[0]x[1] as the bits, and x[2]x[3] as the bits.
    // Let's try mapping the 4 bits directly as {x[3], x[2], x[1], x[0]}.
    // 0000: 1
    // 0001: 0
    // 0011: 0
    // 0010: 1
    // 0100: 0
    // ...
    // This is equivalent to what I tried.

    // Could the input be {x[0], x[1], x[2], x[3]} where x[0] is MSB?
    // Then Row is x[0]x[1], Col is x[2]x[3]?
    // That's what I tried.

    // Let's re-examine the table:
    // Could it be 00, 01, 10, 11? No, K-maps are always Gray code.
    
    // Let's try the boolean function directly.
    // f = (~x2 & ~x3 & ~x0 & ~x1) | (~x2 & ~x3 & x0 & ~x1) ... 
    // This is just a K-map simplification.
    
    // Let's re-read the values:
    // Row 00: 1, 0, 0, 1 (f=1 for 0000, 0010)
    // Row 01: 0, 0, 0, 0 (f=0)
    // Row 11: 1, 1, 1, 0 (f=1 for 1100, 1101, 1111)
    // Row 10: 1, 1, 0, 1 (f=1 for 1000, 1001, 1010)
    
    // Maybe the input bits order is {x[0], x[1], x[2], x[3]}?
    // Row: x[2]x[3], Col: x[0]x[1]
    // 0000 -> x[2]=0, x[3]=0, x[0]=0, x[1]=0. Table[0,0] = 1. Correct.
    // 0001 -> x[2]=0, x[3]=0, x[0]=0, x[1]=1. Table[0,1] = 0. Correct.
    // 0010 -> x[2]=0, x[3]=0, x[0]=1, x[1]=0. Table[0,2] = 0. Wait, this should be 1?
    // In my previous truth table:
    // x[0]x[1] indices are 00, 01, 11, 10.
    // So Column 2 (index 2) is 11, Column 3 (index 3) is 10.
    // Table[0, 0] = 1 (00,00)
    // Table[0, 1] = 0 (00,01)
    // Table[0, 2] = 0 (00,11)
    // Table[0, 3] = 1 (00,10)
    
    // If x = {x[0], x[1], x[2], x[3]}, then:
    // 0010 = {x[0]=0, x[1]=0, x[2]=1, x[3]=0} -> Row=2, Col=0 -> Table[2,0]=1
    // My previous truth table had 0010 as 1.
    // Let's re-calculate:
    // Row 0, Col 0 (00,00) -> 1
    // Row 0, Col 3 (00,10) -> 1
    // Row 2, Col 0 (11,00) -> 1
    // Row 2, Col 1 (11,01) -> 1
    // Row 2, Col 2 (11,11) -> 1
    // Row 3, Col 0 (10,00) -> 1
    // Row 3, Col 1 (10,01) -> 1
    // Row 3, Col 3 (10,10) -> 1
    
    // Using x = {x[0], x[1], x[2], x[3]}
    // Indices:
    // Row(x[2]x[3]) Col(x[0]x[1])
    // 00, 00 = 0000 -> 1
    // 00, 10 = 0010 -> 1
    // 11, 00 = 0011 -> 1? No, 1100
    // This is confusing. Let's just implement the logic directly from the map.
    
    // f = (Row00 & Col00) | (Row00 & Col10) | (Row11 & Col00) | (Row11 & Col01) | (Row11 & Col11) | (Row10 & Col00) | (Row10 & Col01) | (Row10 & Col10)
    
    // Let Row00 = (~x[2] & ~x[3])
    // Let Row01 = (~x[2] & x[3])
    // Let Row11 = (x[2] & x[3])
    // Let Row10 = (x[2] & ~x[3])
    
    // Let Col00 = (~x[0] & ~x[1])
    // Let Col01 = (~x[0] & x[1])
    // Let Col11 = (x[0] & x[1])
    // Let Col10 = (x[0] & ~x[1])
    
    // This logic covers all 1s in the table.
    
    always @(*) begin
        f = ((~x[2] & ~x[3]) & ((~x[0] & ~x[1]) | (x[0] & ~x[1]))) |
            ((x[2] & x[3]) & ((~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & x[1]))) |
            ((x[2] & ~x[3]) & ((~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & ~x[1])));
    end
endmodule
