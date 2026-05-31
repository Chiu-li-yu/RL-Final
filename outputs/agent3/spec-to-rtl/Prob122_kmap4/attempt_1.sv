module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    logic out_temp;

    always @(*) begin
        // Mapping the K-map:
        // Rows (cd): 00, 01, 11, 10
        // Cols (ab): 00, 01, 11, 10
        //
        // K-map:
        //      ab 00 01 11 10
        // cd 00 | 0  1  0  1 |
        //    01 | 1  0  1  0 |
        //    11 | 0  1  0  1 |
        //    10 | 1  0  1  0 |
        //
        // This is XOR of (a ^ b) and (c ^ d)
        // Let's verify:
        // if a=0, b=0: XOR=0. If c=0, d=0: XOR=0. Result 0. Correct.
        // if a=0, b=1: XOR=1. If c=0, d=0: XOR=0. Result 1. Correct.
        // if a=1, b=1: XOR=0. If c=0, d=0: XOR=0. Result 0. Correct.
        // if a=1, b=0: XOR=1. If c=0, d=0: XOR=0. Result 1. Correct.
        // if a=0, b=0: XOR=0. If c=0, d=1: XOR=1. Result 1. Correct.
        // ... looks like out = a ^ b ^ c ^ d
        out_temp = a ^ b ^ c ^ d;
    end

    assign out = out_temp;

endmodule
