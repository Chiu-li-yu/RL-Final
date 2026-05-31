module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    logic out_temp;

    always @(*) begin
        // K-Map Analysis:
        // Inputs: a, b (rows), c, d (cols)
        // Order: ab | cd
        // Map:
        //     | 00 | 01 | 11 | 10
        // ----+----+----+----+----
        // 00  | 0  | 1  | 0  | 1
        // 01  | 1  | 0  | 1  | 0
        // 11  | 0  | 1  | 0  | 1
        // 10  | 1  | 0  | 1  | 0

        // The pattern is a standard XOR check:
        // out = a ^ b ^ c ^ d
        // Let's verify:
        // ab\cd | 00 | 01 | 11 | 10
        // ------+----+----+----+----
        // 00    | 0  | 1  | 0  | 1  -> c ^ d
        // 01    | 1  | 0  | 1  | 0  -> ~(c ^ d)
        // 11    | 0  | 1  | 0  | 1  -> c ^ d
        // 10    | 1  | 0  | 1  | 0  -> ~(c ^ d)

        // If a^b is 0 (00, 11), out = c^d
        // If a^b is 1 (01, 10), out = ~(c^d)
        // Therefore: out = (a ^ b) ^ ~(c ^ d)
        // Which is equivalent to a ^ b ^ (~c ^ ~d) = a ^ b ^ c ^ d.

        out_temp = a ^ b ^ c ^ d;
    end

    assign out = out_temp;
endmodule