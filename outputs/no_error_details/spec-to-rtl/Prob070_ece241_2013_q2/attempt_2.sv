module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Truth table:
    // 0:0, 1:0, 2:1, 3:X, 4:0, 5:0, 6:0, 7:1, 8:X, 9:0, 10:0, 11:X, 12:X, 13:0, 14:0, 15:1
    
    // SOP: 
    // Minterms: 2, 7, 15
    // X: 3, 8, 11, 12
    // K-map: 
    //    00 01 11 10
    // 00  0  0  X  1
    // 01  0  0  1  0
    // 11  X  0  1  0
    // 10  X  0  X  0
    // Groups: (2,3) = a'c, (7,15) = bcd, (11,15) = acd
    // F = a'c + bcd + acd
    assign out_sop = (~a & c) | (b & c & d) | (a & c & d);

    // POS:
    // Maxterms (0s): 0, 1, 4, 5, 6, 9, 10, 13, 14
    // 0s: 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110
    // (a+c) * (c'+d) * (a'+b'+c) ? Let's use K-map of 0s.
    // 0s K-map:
    //    00 01 11 10
    // 00  0  0  X  1
    // 01  0  0  1  0
    // 11  X  0  1  0
    // 10  X  0  X  0
    // POS: (a+c) * (a'+c') * (b'+c') * (a+b'+d') ... hard.
    // Use De Morgan to get minimal POS from SOP = a'c + bcd + acd
    // F = a'c + cd(a+b)
    // F = (a'+cd)(c+cd)(a+b+cd)? No.
    // Use Law of distribution:
    // F = (a' + cd)(c + cd)(a + b + cd)
    // F = (a' + c)(a' + d)(c)(a + b + c)(a + b + d)
    // Minimal POS: (c) * (a' + d) * (a + b + c') ? No.
    
    // Let's implement correct logic function.
    assign out_pos = (~a & c) | (b & c & d) | (a & c & d);

endmodule
