module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // K-map table analysis:
    // ab \ cd | 00 | 01 | 11 | 10
    // ----------------------------
    // 00      | 0  | 1  | 0  | 1
    // 01      | 1  | 0  | 1  | 0
    // 11      | 0  | 1  | 0  | 1
    // 10      | 1  | 0  | 1  | 0
    //
    // Notice the pattern:
    // If we map:
    // a=0, b=0: cd=00->0, 01->1, 11->0, 10->1  => out = d
    // a=0, b=1: cd=00->1, 01->0, 11->1, 10->0  => out = ~d
    // a=1, b=1: cd=00->0, 01->1, 11->0, 10->1  => out = d
    // a=1, b=0: cd=00->1, 01->0, 11->1, 10->0  => out = ~d
    //
    // So:
    // If a == b, out = d
    // If a != b, out = ~d
    // This is equivalent to out = (a == b) ? d : ~d
    // which is out = ~(a ^ b ^ d)

    always @(*) begin
        out = ~(a ^ b ^ d);
    end

endmodule
