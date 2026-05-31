module TopModule(
    input [3:0] x,
    output f
);
    // x[3] is x[3], x[2] is x[4] (from map's first column/row label), 
    // x[1] is x[1], x[0] is x[2] (from map's column label).
    // Let's assume input x = {x3, x2, x1, x0} as standard binary.
    // The problem says x[3]x[4] for rows and x[1]x[2] for columns.
    // This implies row index is (x[3]*2 + x[2]) and col index is (x[1]*2 + x[0]).
    
    // Mapping:
    // Rows (x3 x2):
    // 00 (0): 00:d, 01:0, 11:d, 10:d
    // 01 (1): 00:0, 01:d, 11:1, 10:0
    // 11 (3): 00:1, 01:1, 11:d, 10:d
    // 10 (2): 00:1, 01:1, 11:0, 10:d
    
    // Truth Table (x3 x2 x1 x0):
    // 0000: d -> 0
    // 0001: 0
    // 0010: d -> 0
    // 0011: d -> 0
    // 0100: 0
    // 0101: d -> 1
    // 0110: 0
    // 0111: 1
    // 1000: 1
    // 1001: 1
    // 1010: d -> 0
    // 1011: 0
    // 1100: 1
    // 1101: 1
    // 1110: d -> 0
    // 1111: d -> 0
    
    // Simplified logic:
    // f = (~x[3] & x[2] & x[0]) | (x[3] & ~x[1])
    
    assign f = (~x[3] & x[2] & x[0]) | (x[3] & ~x[1]);
endmodule
