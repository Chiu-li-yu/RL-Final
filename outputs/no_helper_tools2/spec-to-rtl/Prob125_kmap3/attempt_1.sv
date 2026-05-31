module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Karnaugh Map (ab at columns, cd at rows)
    //        ab
    //   cd | 00 | 01 | 11 | 10
    //   -----------------------
    //   00 |  0 |  d |  1 |  1
    //   01 |  0 |  0 |  d |  d
    //   11 |  1 |  0 |  1 |  1
    //   10 |  1 |  0 |  1 |  1
    //
    // Note: The K-map in the prompt provided columns as (01, 00, 10, 11)
    // and rows as (00, 01, 11, 10).
    // Let's re-map based on the provided table:
    // Columns (ab):
    // Column 1: 01 (Value: d, 0, 0, 0) -> Treat 'd' as 0
    // Column 2: 00 (Value: 0, 0, 1, 1)
    // Column 3: 10 (Value: 1, d, 1, 1) -> Treat 'd' as 1
    // Column 4: 11 (Value: 1, d, 1, 1) -> Treat 'd' as 1
    //
    // Truth Table:
    // a b c d | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | 0
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | 0
    // 0 1 1 1 | 0
    // 1 0 0 0 | 1
    // 1 0 0 1 | 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 1
    // 1 1 0 1 | 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1

    logic out_val;
    always @(*) begin
        // K-map simplification:
        // out = a + (!b & c)
        out_val = a | (~b & c);
    end

    assign out = out_val;

endmodule
