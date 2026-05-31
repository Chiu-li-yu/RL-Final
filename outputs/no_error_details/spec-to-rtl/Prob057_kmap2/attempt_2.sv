module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map (ab | cd):
    // ab=00: cd=00(1), 01(1), 11(0), 10(1)
    // ab=01: cd=00(1), 01(0), 11(0), 10(1)
    // ab=11: cd=00(0), 01(1), 11(1), 10(1)
    // ab=10: cd=00(1), 01(1), 11(0), 10(0)

    // Truth Table:
    // a b c d | out
    // 0 0 0 0 | 1
    // 0 0 0 1 | 1
    // 0 0 1 0 | 1
    // 0 0 1 1 | 0
    // 0 1 0 0 | 1
    // 0 1 0 1 | 0
    // 0 1 1 0 | 1
    // 0 1 1 1 | 0
    // 1 0 0 0 | 1
    // 1 0 0 1 | 1
    // 1 0 1 0 | 0
    // 1 0 1 1 | 0
    // 1 1 0 0 | 0
    // 1 1 0 1 | 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1

    logic out_logic;

    always @(*) begin
        out_logic = (~a & ~b & ~c & ~d) | 
                    (~a & ~b & ~c &  d) | 
                    (~a & ~b &  c & ~d) | 
                    (~a &  b & ~c & ~d) | 
                    (~a &  b &  c & ~d) | 
                    ( a & ~b & ~c & ~d) | 
                    ( a & ~b & ~c &  d) | 
                    ( a &  b & ~c &  d) | 
                    ( a &  b &  c & ~d) | 
                    ( a &  b &  c &  d);
    end

    assign out = out_logic;
endmodule
