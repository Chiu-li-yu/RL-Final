module TopModule (
    input [3:0] in,
    output logic [1:0] pos
);

    // Maybe the index is 1-based?
    // bit[0] -> 1, bit[1] -> 2, bit[2] -> 3, bit[3] -> 0 (or 4, but only 2 bits)
    // Let's try:
    // bit[3] is priority 1, bit[2] priority 2...
    // 8'b10010000 -> 4. This is a 1-based index (bit 4 is index 4).
    // So for 4 bits:
    // bit[0] is index 1, bit[1] is index 2, bit[2] is index 3, bit[3] is index 4?
    // But 2 bits can only store 0-3.
    // Maybe bit[0] is index 0?
    // Let's try:
    // if in[0] is set, pos = 1 (1-based index)
    // if in[1] is set, pos = 2
    // if in[2] is set, pos = 3
    // if in[3] is set, pos = 0 (maybe wrap around or 4 doesn't fit?)
    
    // Actually, look at "first 1 bit". 
    // If input is 8'b10010000, 4th bit (index 4) is high. 
    // In 4-bit, bits are 3,2,1,0.
    // If bit[0] is high, it is the 1st bit.
    // If bit[3] is high, it is the 4th bit.
    
    always @(*) begin
        if (in[0])
            pos = 2'd1;
        else if (in[1])
            pos = 2'd2;
        else if (in[2])
            pos = 2'd3;
        else if (in[3])
            pos = 2'd0;
        else
            pos = 2'd0;
    end
endmodule
