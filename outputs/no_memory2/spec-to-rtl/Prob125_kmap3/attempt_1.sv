module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map table (cd | ab):
    //      00 01 10 11
    // 00 | 0  d  1  1
    // 01 | 0  0  d  d
    // 11 | 1  0  1  1
    // 10 | 1  0  1  1
    
    // Mapping table index: (c,d) | (a,b)
    // 0000: 0
    // 0001: d(0)
    // 0010: 1
    // 0011: 1
    // 0100: 0
    // 0101: 0
    // 0110: d(1)
    // 0111: d(1)
    // 1000: 1
    // 1001: 0
    // 1010: 1
    // 1011: 1
    // 1100: 1
    // 1101: 0
    // 1110: 1
    // 1111: 1

    // Logic implementation using combinational logic
    assign out = (a & ~b) | (a & ~c) | (b & ~c & ~d) | (a & c & d);

endmodule