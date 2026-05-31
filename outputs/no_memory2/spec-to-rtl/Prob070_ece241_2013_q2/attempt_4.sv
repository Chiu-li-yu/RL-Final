module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Inputs: a (MSB), b, c, d (LSB)
    // Numbers: 0(0000), 1(0001), 2(0010), 3(0011-DC), 4(0100), 5(0101), 6(0110), 7(0111), 8(1000-DC), 9(1001), 10(1010), 11(1011-DC), 12(1100-DC), 13(1101), 14(1110), 15(1111)
    
    // Truth Table:
    // 0000: 0
    // 0001: 0
    // 0010: 1
    // 0011: X
    // 0100: 0
    // 0101: 0
    // 0110: 0
    // 0111: 1
    // 1000: X
    // 1001: 0
    // 1010: 0
    // 1011: X
    // 1100: X
    // 1101: 0
    // 1110: 0
    // 1111: 1

    // SOP minimization (Min terms 2, 7, 15; DC 3, 8, 11, 12):
    // K-map:
    //      cd 00 01 11 10
    // ab 00    0  0  X  1
    //    01    0  0  1  0
    //    11    X  0  1  0
    //    10    X  0  X  0
    //
    // Groups for 1s:
    // 1. (0,0,1,0) and (0,0,1,1) -> ~a~b d
    // 2. (0,1,1,1) and (1,1,1,1) -> b c d
    //
    // out_sop = (~a & ~b & d) | (b & c & d)

    // POS minimization (Zero groups):
    // 0s at: 0, 1, 4, 5, 6, 9, 10, 13, 14
    // 1s/DC at: 2, 3, 7, 8, 11, 12, 15
    // K-map for 0s:
    //      cd 00 01 11 10
    // ab 00    0  0  1  1
    //    01    0  0  1  1
    //    11    1  0  1  1
    //    10    1  0  1  1
    // Groups for 0s:
    // 1. (0,0,0,0),(0,0,0,1),(0,1,0,0),(0,1,0,1) -> ~a ~c
    // 2. (0,1,0,0),(0,1,1,0),(1,1,0,0),(1,1,1,0) -> ~b ~d (Wait, 12 is DC, 8 is DC)
    // Refined POS K-map:
    //      cd 00 01 11 10
    // ab 00    0  0  X  1
    //    01    0  0  1  0
    //    11    X  0  1  0
    //    10    X  0  X  0
    //
    // POS: (c | d) & (~b | d) & (~a | b | c) -- Let's re-calculate or stick to SOP.
    // Actually, SOP can be factored to POS?
    // SOP = d(~a~b + bc)
    // SOP = d(~a~b + c)(~a~b + b) = d(c + ~a)(c + ~b)(~a + b)(~b + b) = d(c + ~a)(c + ~b)(~a + b)
    // POS = d & (c | ~a) & (c | ~b) & (b | ~a)

    always @(*) begin
        out_sop = (~a & ~b & d) | (b & c & d);
        out_pos = d & (c | ~a) & (c | ~b) & (b | ~a);
    end

endmodule
