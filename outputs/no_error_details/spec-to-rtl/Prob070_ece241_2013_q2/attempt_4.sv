module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Let's use the explicit truth table for a 4-variable function.
    // 0, 1, 4, 5, 6, 9, 10, 13, 14 => 0
    // 2, 7, 15 => 1
    // 3, 8, 11, 12 => X (let's map X to 1 if it helps simplify)
    
    // F(a,b,c,d) = Sum of minterms (2, 7, 15) + dc (3, 8, 11, 12)
    // Map:
    // 0000:0, 0001:0, 0010:1, 0011:X, 0100:0, 0101:0, 0110:0, 0111:1
    // 1000:X, 1001:0, 1010:0, 1011:X, 1100:X, 1101:0, 1110:0, 1111:1
    
    // SOP minimization:
    // Group 1: 0010, 0011 -> ~a & ~b & c
    // Group 2: 0011, 0111, 1011, 1111 -> c & d
    // Wait, let's look at K-map again.
    //    cd 00 01 11 10
    // ab 00  0  0  X  1
    // ab 01  0  0  1  0
    // ab 11  X  0  1  0
    // ab 10  X  0  X  0
    
    // K-map with X=1:
    //    cd 00 01 11 10
    // 00  0  0  1  1 -> ~a & ~b & c
    // 01  0  0  1  0 -> ~a & b & c & d
    // 11  1  0  1  0 -> a & b & c & d
    // 10  1  0  1  0 -> a & ~b & c & d
    // Simplified: (c & d) | (~a & ~b & c) | (b & c & d) ... not optimal.
    
    // Minimal SOP: c & (d | ~a & ~b)  => (c & d) | (~a & ~b & c)
    assign out_sop = (c & d) | (~a & ~b & c);
    
    // POS: (c) & (a' + d) & (a + b + c') ... Let's use the same logic as SOP
    // since for the defined points (2, 7, 15), both must be 1.
    // The question asks for MINIMUM SOP and MINIMUM POS.
    // If the function is the same, POS is also (c) & (a' + d) ...?
    assign out_pos = c & (~a | d) & (a | b | ~c);

endmodule
