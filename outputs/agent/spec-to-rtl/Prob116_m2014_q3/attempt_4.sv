module TopModule (
    input [3:0] x,
    output f
);
    // Let's re-read the K-map labels carefully.
    // row label: x[3]x[4]  col label: x[1]x[2]
    // The input is x = [x3, x2, x1, x0].
    // Maybe x[3]x[4] in the K-map actually means the two bits x[3] and x[2]?
    // And x[1]x[2] means the two bits x[1] and x[0]?
    
    // K-map:
    // row (x3x2) \ col (x1x0) | 00 | 01 | 11 | 10
    // 00                      | d  | 0  | d  | d
    // 01                      | 0  | d  | 1  | 0
    // 11                      | 1  | 1  | d  | d
    // 10                      | 1  | 1  | 0  | d
    
    // If I pick:
    // (00,00)=1, (00,11)=1, (00,10)=1
    // (01,01)=1
    // (11,11)=1, (11,10)=1
    // (10,10)=1
    // This is choosing 'd's.
    
    // Truth table based on provided K-map:
    // Row 00 (x3x2=00): f = d0dd -> f(0000)=1, f(0001)=0, f(0011)=1, f(0010)=1
    // Row 01 (x3x2=01): f = 0d10 -> f(0100)=0, f(0101)=1, f(0111)=1, f(0110)=0
    // Row 11 (x3x2=11): f = 11dd -> f(1100)=1, f(1101)=1, f(1111)=1, f(1110)=1
    // Row 10 (x3x2=10): f = 110d -> f(1000)=1, f(1001)=1, f(1011)=0, f(1010)=1
    
    // Now f = 1 for:
    // 0000, 0011, 0010
    // 0101, 0111
    // 1100, 1101, 1111, 1110
    // 1000, 1001, 1010
    
    // f = 1 when x3=1 OR x2=1 OR (~x3 & ~x2 & ~x0)
    // Let's test this:
    // 0000: (0|0|1) = 1 (Correct)
    // 0001: (0|0|0) = 0 (Correct)
    // 0010: (0|0|0) = 0 (Wait, 0010 should be 1? My logic says 0. Let's re-check.)
    // f = x3 | x2 | (~x3 & ~x2 & ~x1 & ~x0) --- wait, 0000 should be 1. 0001 should be 0.
    
    // Let's use K-Map solver again.
    // Input indices:
    // 0000:1, 0001:0, 0010:1, 0011:1
    // 0100:0, 0101:1, 0110:0, 0111:1
    // 1100:1, 1101:1, 1110:1, 1111:1
    // 1000:1, 1001:1, 1010:1, 1011:0
    
    // K-map:
    //    x1x0
    // x3x2 00 01 11 10
    // 00 | 1 | 0 | 1 | 1
    // 01 | 0 | 1 | 1 | 0
    // 11 | 1 | 1 | 1 | 1
    // 10 | 1 | 1 | 0 | 1
    
    // Groups:
    // - x3=1 (covers 1000,1001,1010,1011,1100,1101,1110,1111)
    // - x2=1 (covers 0101,0111,1100,1101,1110,1111)
    // - x3=0, x2=0, x0=0 (0000)
    // - x3=0, x2=0, x1=1 (0010, 0011)
    // - x3=0, x1=1, x0=1 (0111)
    
    // f = x3 | x2 | (~x3 & ~x2 & ~x0) | (~x3 & ~x2 & x1)
    // f = x3 | x2 | (~x3 & ~x2 & (~x0 | x1))
    
    assign f = x[3] | x[2] | (~x[3] & ~x[2] & (~x[0] | x[1]));

endmodule