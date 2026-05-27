module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Karnaugh Map analysis:
    //      ab
    // cd  00 01 11 10
    // 00 | 0 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 1 | 0 |
    // 11 | 0 | 1 | 0 | 1 |
    // 10 | 1 | 0 | 1 | 0 |
    //
    // The pattern is a XOR b XOR c XOR d
    // Let's verify:
    // (a,b,c,d) -> out
    // 0,0,0,0 -> 0 (K-map: 0)
    // 0,0,0,1 -> 1 (K-map: 1)
    // 0,0,1,0 -> 1 (K-map: 1)
    // 0,0,1,1 -> 0 (K-map: 0)
    // ... this is indeed a XOR b XOR c XOR d
    
    always @(*) begin
        out = a ^ b ^ c ^ d;
    end

endmodule