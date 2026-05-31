module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // K-map:
    // a=0, b=0, c=0 -> 0
    // a=0, b=0, c=1 -> 1
    // a=0, b=1, c=0 -> 1
    // a=0, b=1, c=1 -> 1
    // a=1, b=0, c=0 -> 1
    // a=1, b=0, c=1 -> 1
    // a=1, b=1, c=0 -> 1
    // a=1, b=1, c=1 -> 1
    // Truth table:
    // a b c | out
    // 0 0 0 | 0
    // 0 0 1 | 1
    // 0 1 0 | 1
    // 0 1 1 | 1
    // 1 0 0 | 1
    // 1 0 1 | 1
    // 1 1 0 | 1
    // 1 1 1 | 1
    
    // Logic simplification (Sum of Products):
    // out = (~a & ~b & c) | (~a & b & ~c) | (~a & b & c) | (a & ~b & ~c) | (a & ~b & c) | (a & b & ~c) | (a & b & c)
    // out = a | (~a & b) | (~a & ~b & c) = a | b | c
    // Wait, let's re-verify:
    // if a=0, out = b | c
    // if a=1, out = 1
    // Therefore out = a | b | c is correct.
    
    // Maybe the K-map indexing is different?
    // Map:
    //           a
    //    bc   0   1
    //    00 | 0 | 1 |
    //    01 | 1 | 1 |
    //    11 | 1 | 1 |
    //    10 | 1 | 1 |
    
    // Let's re-read the map:
    // bc=00, a=0 => 0
    // bc=01, a=0 => 1
    // bc=11, a=0 => 1
    // bc=10, a=0 => 1
    // All a=1 entries are 1.
    // Yes, this is exactly a | (b | c) = a | b | c.

    // Let's try assigning carefully:
    logic out_logic;
    assign out_logic = a | b | c;
    
    always @(*) begin
        out = out_logic;
    end
endmodule
