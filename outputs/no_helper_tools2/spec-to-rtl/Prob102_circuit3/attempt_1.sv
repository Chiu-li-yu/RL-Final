module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Analysis:
    // When a=0, b=0: q is always 0
    // When a=0, b=1: q is 1 if (c | d)
    // When a=1, b=0: q is 1 if (c | d)
    // When a=1, b=1: q is 1 if (c | d)
    // Actually, looking at the table:
    // 0000 -> 0
    // 0001 -> 0
    // 0010 -> 0
    // 0011 -> 0
    // 0100 -> 0
    // 0101 -> 1
    // 0110 -> 1
    // 0111 -> 1
    // 1000 -> 0
    // 1001 -> 1
    // 1010 -> 1
    // 1011 -> 1
    // 1100 -> 0
    // 1101 -> 1
    // 1110 -> 1
    // 1111 -> 1
    // q is high if (a|b) AND (c|d)
    
    assign q = (a | b) & (c | d);

endmodule