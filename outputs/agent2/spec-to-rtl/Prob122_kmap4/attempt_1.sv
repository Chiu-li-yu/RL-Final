module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out
);
    // K-map table:
    //      ab
    // cd  00 01 11 10
    // 00 | 0 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 1 | 0 |
    // 11 | 0 | 1 | 0 | 1 |
    // 10 | 1 | 0 | 1 | 0 |
    //
    // Truth table:
    // c d a b | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | 1
    // 0 0 1 0 | 1
    // 0 0 1 1 | 0
    // 0 1 0 0 | 1
    // 0 1 0 1 | 0
    // 0 1 1 0 | 0
    // 0 1 1 1 | 1
    // 1 0 0 0 | 1
    // 1 0 0 1 | 0
    // 1 0 1 0 | 0
    // 1 0 1 1 | 1
    // 1 1 0 0 | 0
    // 1 1 0 1 | 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 0
    //
    // Observational analysis:
    // out = a ^ b ^ c ^ d

    always @(*) begin
        out = a ^ b ^ c ^ d;
    end
endmodule
