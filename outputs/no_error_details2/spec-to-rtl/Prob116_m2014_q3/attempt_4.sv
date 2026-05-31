module TopModule(
    input [3:0] x,
    output f
);
    // K-map given:
    // Row x[3]x[4]  Col x[1]x[2]
    // Wait, the row is x[3]x[4] and column is x[1]x[2].
    // Let's re-read carefully: "x[3]x[4]  00 01 11 10" and "x[1]x[2] 00 01 11 10"
    // Usually indices are x[3], x[2], x[1], x[0]. 
    // The input is "input x (4 bits)".
    // So the input bits are x[3], x[2], x[1], x[0].
    
    // The table shows:
    // Row header: x[3]x[2]? No, "x[3]x[4]"? Maybe there is a typo in the prompt and it should be "x[3]x[2]".
    // Let's assume the rows are x[3]x[2] and cols are x[1]x[0].
    
    // Row   Col   Value
    // 00    00    d
    // 00    01    0
    // 00    11    d
    // 00    10    d
    
    // 01    00    0
    // 01    01    d
    // 01    11    1
    // 01    10    0
    
    // 11    00    1
    // 11    01    1
    // 11    11    d
    // 11    10    d
    
    // 10    00    1
    // 10    01    1
    // 10    11    0
    // 10    10    d

    // Let's use logic mapping the exact cells.
    // Let r = {x[3], x[2]}, c = {x[1], x[0]}
    // f = 1 if (r,c) in {(01,11), (11,00), (11,01), (10,00), (10,01)}
    // 0111: 1
    // 1100: 1
    // 1101: 1
    // 1000: 1
    // 1001: 1

    // Grouping:
    // (1100, 1101, 1000, 1001) -> r={1, x}, c={0, x} -> x[3] & ~x[1]
    // (0111, 1111) -> wait, is 1111 a 1? Yes, d can be 1.
    // If 1111 is 1: (0111, 1111) -> r={x, 1}, c={1, 1} -> x[2] & x[1] & x[0]
    
    assign f = (x[3] & ~x[1]) | (x[2] & x[1] & x[0]);
endmodule
