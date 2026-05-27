module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Inputs a, b, c, d represent 8, 4, 2, 1
    // Values:
    // 0: 0000 -> 0
    // 1: 0001 -> 0
    // 2: 0010 -> 1
    // 3: 0011 -> X
    // 4: 0100 -> 0
    // 5: 0101 -> 0
    // 6: 0110 -> 0
    // 7: 0111 -> 1
    // 8: 1000 -> X
    // 9: 1001 -> 0
    // 10: 1010 -> 0
    // 11: 1011 -> X
    // 12: 1100 -> X
    // 13: 1101 -> 0
    // 14: 1110 -> 0
    // 15: 1111 -> 1

    // K-map:
    //      cd
    // ab   00 01 11 10
    // 00   0  0  1  1
    // 01   0  0  1  0
    // 11   X  0  1  0
    // 10   X  0  X  0

    // out_sop (Sum of Products):
    // Minimum SOP:
    // Groups: (0010, 0011), (0111, 0011, 1011, 1111) -> wait, 0011 is X, 1011 is X, 1111 is 1
    // Correct groupings using Don't Cares (3, 8, 11, 12):
    // 1s at: 2(0010), 7(0111), 15(1111)
    // Xs at: 3(0011), 8(1000), 11(1011), 12(1100)

    // Simplified sop:
    // Group 1: m2+m3 (001x) -> !a!bc
    // Group 2: m7+m15 (x111) -> bcd
    // Result: (!a & !b & c) | (b & c & d)
    // Actually: 
    // m2(0010), m3(0011) -> !a!bc
    // m7(0111), m15(1111) -> bcd
    // Check m11: 1011. If we include it, we get (!a!bc + bcd). Let's check 2,7,15.
    // 2: 0010 -> 1|0 = 1.
    // 7: 0111 -> 0|1 = 1.
    // 15: 1111 -> 0|1 = 1.
    // Looks good.

    // out_pos (Product of Sums):
    // POS: (a+b+c)(a+!b+d)...
    // Map 0s: 0(0000), 1(0001), 4(0100), 5(0101), 6(0110), 9(1001), 10(1010), 13(1101), 14(1110)
    // Dual map for POS (product of maxterms where output is 0):
    // Minimized POS:
    // (a+c) * (!b+c) * (b+!c+!d) ... this is getting complex.
    // Let's use the truth table directly for POS.
    // POS = (a+b+c) * (a+b+!d) * (a+!b+!c) * (!a+!b+!c) ...
    // Let's simplify with K-map for 0s.
    
    // Minimal POS:
    // The expression is: (a+c) * (!b+c) * (b+!c+!d)
    
    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = (a | c) & (~b | c) & (b | ~c | ~d);

endmodule
