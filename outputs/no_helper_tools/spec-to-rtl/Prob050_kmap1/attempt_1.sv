module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Karnaugh Map:
    //      a
    // bc  0 1
    // 00  0 1
    // 01  1 1
    // 11  1 1
    // 10  1 1
    //
    // Sum of products (minterms):
    // (a=0, b=0, c=1) -> a'b'c
    // (a=0, b=1, c=1) -> a'bc
    // (a=0, b=1, c=0) -> a'bc'
    // (a=1, b=0, c=0) -> ab'c'
    // (a=1, b=0, c=1) -> ab'c
    // (a=1, b=1, c=1) -> abc
    // (a=1, b=1, c=0) -> abc'
    //
    // Simplifying:
    // a=1 is always 1.
    // a=0 is 1 when (b=1) or (b=0 and c=1) -> b + c
    // So: a + (b + c) = a + b + c

    logic out_logic;

    always @(*) begin
        out_logic = a | b | c;
    end

    assign out = out_logic;

endmodule
