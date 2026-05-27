module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Truth table:
    // a b c d | Output
    // 0 0 0 0 | 0
    // 0 0 0 1 | 0
    // 0 0 1 0 | 1 (2)
    // 0 0 1 1 | X (3)
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | 0
    // 0 1 1 1 | 1 (7)
    // 1 0 0 0 | X (8)
    // 1 0 0 1 | 0
    // 1 0 1 0 | 0
    // 1 0 1 1 | X (11)
    // 1 1 0 0 | X (12)
    // 1 1 0 1 | 0
    // 1 1 1 0 | 0
    // 1 1 1 1 | 1 (15)

    // K-map (Output):
    //    cd 00 01 11 10
    // ab 00  0  0  X  1
    //    01  0  0  1  0
    //    11  X  0  1  0
    //    10  X  0  X  0

    // SOP minimization:
    // 1s at (0,0,1,0), (0,1,1,1), (1,1,1,1)
    // Xs at (0,0,1,1), (1,0,0,0), (1,0,1,1), (1,1,0,0)
    // Prime Implicants:
    // !a!bc (includes 2, 3)
    // bc (includes 3, 7, 11, 15) - wait, if we use X at 3 and 11, this covers 7 and 15 too.
    // So SOP = (!a & !b & c) | (b & c)
    // Check: 
    // 2: !0!01 = 1 | 0 = 1. (Correct)
    // 7: !0!11 = 0 | (1&1) = 1. (Correct)
    // 15: !1!11 = 0 | (1&1) = 1. (Correct)
    
    // POS minimization:
    // 0s at 0, 1, 4, 5, 6, 9, 10, 13, 14
    // Looking at the zeros in K-map:
    // POS = (c) * (!b + !c + !d) * ... this is not trivial.
    // Let's re-evaluate POS map:
    // The inverse of the function (output 0) is easier to see.
    // The expression for 1 is (c & (!a | b)) is incorrect.
    // Let's re-derive:
    // SOP: c & (!a | b)
    // POS: c & (!a | b)  -- Wait, are they same?
    // Let's test c & (!a | b):
    // 2 (0010): 1 & (1|0) = 1
    // 7 (0111): 1 & (1|1) = 1
    // 15 (1111): 1 & (0|1) = 1
    // Correct!
    
    // So SOP: c & (~a | b)  => (~a & c) | (b & c)
    // POS: c & (~a | b) => (c) & (~a | b)
    
    assign out_sop = (~a & c) | (b & c);
    assign out_pos = c & (~a | b);

endmodule
