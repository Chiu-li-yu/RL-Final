module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Inputs: a, b, c, d (a is MSB, d is LSB)
    // 0000(0)  -> 0
    // 0001(1)  -> 0
    // 0010(2)  -> 1
    // 0011(3)  -> X
    // 0100(4)  -> 0
    // 0101(5)  -> 0
    // 0110(6)  -> 0
    // 0111(7)  -> 1
    // 1000(8)  -> X
    // 1001(9)  -> 0
    // 1010(10) -> 0
    // 1011(11) -> X
    // 1100(12) -> X
    // 1101(13) -> 0
    // 1110(14) -> 0
    // 1111(15) -> 1

    // K-map:
    //      cd
    // ab  00 01 11 10
    // 00  0  0  1  1
    // 01  0  0  1  0
    // 11  X  0  1  0
    // 10  X  0  X  0

    // SOP (1s at 2, 7, 15):
    // 2: 0010
    // 7: 0111
    // 15: 1111
    // X (don't care): 3 (0011), 8 (1000), 11 (1011), 12 (1100)

    // Using K-Map to simplify:
    // Minimized SOP: 
    // F = (a' * c * d') + (b * c * d) + (a * b * c * d)
    // Actually:
    // 2: a'b'cd'
    // 7: a'bcd
    // 15: abcd
    // 3: a'b'cd
    // 11: ab'cd
    // 12: abc'd'
    // 8: ab'c'd'

    // Let's use simple logic:
    // The outputs are identical for SOP and POS as they are just boolean functions.
    // logic = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d)
    // Simplified:
    // ~a & c & (~b & ~d | b & d) -> (~a & c & (b == d))
    // plus the case 15: a & b & c & d
    
    // Actually, minterm 2: a'b'cd', 7: a'bcd, 15: abcd
    // X: 3 (a'b'cd), 8 (ab'c'd'), 11 (ab'cd), 12 (abc'd')

    // SOP: F = c*d*b + a*c*d + c*d'*b' (Let's verify)
    // 2 (0010): 0 + 0 + 1 = 1 (Correct)
    // 7 (0111): 1 + 0 + 0 = 1 (Correct)
    // 15 (1111): 1 + 1 + 0 = 1 (Correct)
    // 3 (0011): 0 + 0 + 1 = 1 (X)
    // 8 (1000): 0 + 0 + 0 = 0 (X)
    // 11 (1011): 0 + 1 + 0 = 1 (X)
    // 12 (1100): 0 + 0 + 0 = 0 (X)

    // Let's re-simplify with K-Map:
    //      cd
    // ab  00 01 11 10
    // 00  0  0  X  1
    // 01  0  0  1  0
    // 11  X  0  1  0
    // 10  X  0  X  0
    // Grouping:
    // 1. (7, 15): b*c*d
    // 2. (2, 3): a'*b'*c
    // 3. (3, 11): b'*c*d
    // Wait, SOP: (a'b'c) + (bcd)
    
    always @(*) begin
        out_sop = (~a & ~b & c) | (b & c & d);
        out_pos = (~a & ~b & c) | (b & c & d);
    end

endmodule
