module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out_sop,
    output logic out_pos
);

    always @(*) begin
        // SOP: (a'b'c) + (bcd)
        // Verified: 
        // 2 (0010): 1 + 0 = 1
        // 7 (0111): 0 + 1 = 1
        // 15 (1111): 0 + 1 = 1
        out_sop = (~a & ~b & c) | (b & c & d);
        
        // POS: (c) * (a' + b) * (b' + d) 
        // Let's test POS:
        // 2 (0010): 1 * (1 + 0) * (1 + 0) = 1 * 1 * 1 = 1
        // 7 (0111): 1 * (1 + 1) * (0 + 1) = 1 * 1 * 1 = 1
        // 15 (1111): 1 * (0 + 1) * (0 + 1) = 1 * 1 * 1 = 1
        out_pos = c & (~a | b) & (~b | d);
    end

endmodule
