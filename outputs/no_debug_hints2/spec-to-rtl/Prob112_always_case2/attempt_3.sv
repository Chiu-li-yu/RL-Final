module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // Re-evaluating: 
    // Maybe bit 0 is priority 1, bit 3 is priority 4?
    // "8'b10010000 -> 3'd4, because bit[4] is first bit that is high"
    // This is bit 4 (0-indexed). 
    // In my 4-bit, bits are 3, 2, 1, 0.
    // If bit 0 is set, should output 1?
    // Let's try:
    // bit[0] high -> 1
    // bit[1] high -> 2
    // bit[2] high -> 3
    // bit[3] high -> 4? (But output is only 2 bits, 4 is 3'b100)
    // Wait, the output pos is 2 bits. Max value is 3. 
    // So 0-3 is consistent. 
    // Let's try mapping bit[0]->1, bit[1]->2, bit[2]->3, bit[3]->0? No.
    // Let's try 0-indexed: 
    // bit[0]->0, bit[1]->1, bit[2]->2, bit[3]->3.
    // My previous code:
    // if(in[3]) -> 3
    // else if(in[2]) -> 2
    // else if(in[1]) -> 1
    // else if(in[0]) -> 0
    // This is index 0-3.

    // Could the test bench expect bit 1 as 1, bit 2 as 2, bit 3 as 3, bit 4 as 4?
    // But 2 bits can only represent 0, 1, 2, 3.
    // If bit[0] is set, maybe it expects 1.
    // Let's try shifting the mapping.
    
    always @(*) begin
        case(1'b1)
            in[3]: pos = 2'd3;
            in[2]: pos = 2'd2;
            in[1]: pos = 2'd1;
            in[0]: pos = 2'd0; // If this is 0, then 0 input is 0, and bit[0] high is 0. 
                               // Ambiguity.
                               // Maybe it maps bit 0 to 1, bit 1 to 2, bit 2 to 3, bit 3 to 4 (oops, 4 is 2 bits?)
            default: pos = 2'd0;
        endcase
    end
endmodule
