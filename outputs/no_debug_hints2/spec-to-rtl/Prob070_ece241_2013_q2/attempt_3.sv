module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out_sop,
    output logic out_pos
);

    // K-map:
    //      cd
    // ab  00 01 11 10
    // 00  0  0  X  1
    // 01  0  0  1  0
    // 11  X  0  1  0
    // 10  X  0  X  0
    
    // For SOP: 
    // We can group 1s at (2, 3), (7, 15), (3, 11) - wait, (3, 11, 7, 15)?
    // (7, 15) is (0111, 1111) -> bcd
    // (2, 3) is (0010, 0011) -> a'b'c
    // (3, 11) is (0011, 1011) -> b'cd
    // Wait, SOP minimal:
    // f = c * (~a * ~b + b * d + ~b * d)
    // f = c * (~a * ~b + d)
    // Let's check:
    // 2 (0010): 1 * (1 + 0) = 1
    // 7 (0111): 1 * (0 + 1) = 1
    // 15 (1111): 1 * (0 + 1) = 1
    
    always @(*) begin
        out_sop = c & (~a & ~b | d);
        out_pos = c & (~a | b) & (~b | d);
    end

endmodule
