module TopModule (
    input logic a,
    input logic b,
    input logic c,
    output logic out
);

    // Karnaugh Map analysis:
    // a\bc | 00 | 01 | 11 | 10
    // -----|----|----|----|----
    //   0  | 0  | 1  | 1  | 1
    //   1  | 1  | 1  | 1  | 1
    //
    // Truth Table:
    // a b c | out
    // 0 0 0 | 0
    // 0 0 1 | 1
    // 0 1 0 | 1
    // 0 1 1 | 1
    // 1 0 0 | 1
    // 1 0 1 | 1
    // 1 1 0 | 1
    // 1 1 1 | 1
    //
    // The output is 0 only when a=0, b=0, c=0.
    // Therefore, out = NOT(~a & ~b & ~c) = a | b | c

    always @(*) begin
        out = a | b | c;
    end

endmodule