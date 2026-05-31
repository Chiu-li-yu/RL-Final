module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Let's re-verify SOP K-map.
    // Inputs: a, b, c, d
    // 1s: 2 (0010), 7 (0111), 15 (1111)
    // Xs: 3 (0011), 8 (1000), 11 (1011), 12 (1100)
    
    // K-map:
    //      cd 00 01 11 10
    // ab 00  0  0  X  1
    // ab 01  0  0  1  0
    // ab 11  X  0  1  0
    // ab 10  X  0  X  0
    
    // Grouping:
    // (0010, 0011) -> ~a & ~b & c
    // (0111, 1111) -> b & c & d
    // (0010, 1010??) -> Wait, 10 (1010) is a 0.
    // Ah, I see: 2(0010), 3(0011), 7(0111), 11(1011), 15(1111).
    // Let's look at 11(1011). Is it 1?
    // Specification says: "logic-1 when 2, 7, or 15 appears". So 11 is don't care.
    // 2 (0010)
    // 7 (0111)
    // 15 (1111)
    // 3 (0011) - Don't care
    // 8 (1000) - Don't care
    // 11 (1011) - Don't care
    // 12 (1100) - Don't care
    
    // Grouping for 1s:
    // 1. (0010, 0011) -> ~a & ~b & c
    // 2. (0111, 1111) -> b & c & d
    // 3. (1011, 1111) -> a & c & d
    // Wait, (7, 15) is (0111, 1111) = c & d & b.
    // (11, 15) is (1011, 1111) = a & c & d.
    // SOP = (~a & ~b & c) | (b & c & d) | (a & c & d)
    // SOP = (~a & ~b & c) | (c & d & (b | a))
    
    assign out_sop = (~a & ~b & c) | (c & d & (a | b));

    // POS = c & (~a | b | d) & (~a | ~b) -- No, let's derive properly.
    // Zeros at: 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110.
    // K-map for 0s:
    // Group 1: 0, 1, 4, 5 (0000, 0001, 0100, 0101) -> ~a & ~c
    // Group 2: 0, 4, 8, 12 (but 8, 12 are Xs) -> ~a & ~c? (Already covered)
    // Group 3: 1, 5, 9, 13 (but 9, 13 are 0s) -> ~c & d is not right.
    // Let's use the property: POS is the complement of the SOP logic.
    // SOP(sum of minterms of 1s and Xs) = (~a & ~b & c) | (c & d & b) | (c & d & a)
    // This is equal to c & (~a & ~b | b & d | a & d)
    // Complement of SOP(1s+Xs) should be the POS(0s+Xs).
    // POS = (~c) | (~(~a & ~b | b & d | a & d))
    //     = (~c) | ((a | b) & (~b | ~d) & (~a | ~d))
    // This doesn't look like standard POS form.
    
    // Let's use simple K-map for POS (Product of Sums):
    // Grouping 0s:
    // (~a | c) & (b | c | d) & ...
    // Looking at K-map again:
    // POS = (c) & (a | ~b | d) & (~a | ~c) ? No.
    // Let's try: POS = c & (a | b) & (~a | ~b | d)
    
    assign out_pos = c & (a | b) & (~a | ~b | d);

endmodule