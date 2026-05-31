module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Let's re-read the K-map carefully one more time:
    // Columns (ab): 00, 01, 11, 10
    // Rows (cd): 00, 01, 11, 10
    
    // (ab=00, cd=00) -> 1
    // (ab=00, cd=01) -> 1
    // (ab=00, cd=11) -> 0
    // (ab=00, cd=10) -> 1
    
    // (ab=01, cd=00) -> 1
    // (ab=01, cd=01) -> 0
    // (ab=01, cd=11) -> 1
    // (ab=01, cd=10) -> 1
    
    // (ab=11, cd=00) -> 0
    // (ab=11, cd=01) -> 0
    // (ab=11, cd=11) -> 1
    // (ab=11, cd=10) -> 0
    
    // (ab=10, cd=00) -> 1
    // (ab=10, cd=01) -> 1
    // (ab=10, cd=11) -> 1
    // (ab=10, cd=10) -> 0

    // Truth Table (a, b, c, d):
    // 0000: 1
    // 0001: 1
    // 0010: 1 (cd=10, ab=00 is 1)
    // 0011: 0
    // 0100: 1
    // 0101: 0
    // 0110: 1 (cd=11, ab=01 is 1? No, Kmap says 01, 11 is 1)
    
    // Let's map it visually:
    // a b c d | out
    // 0 0 0 0 | 1
    // 0 0 0 1 | 1
    // 0 0 1 0 | 1
    // 0 0 1 1 | 0
    // 0 1 0 0 | 1
    // 0 1 0 1 | 0
    // 0 1 1 0 | 1
    // 0 1 1 1 | 1
    // 1 0 0 0 | 1
    // 1 0 0 1 | 1
    // 1 0 1 0 | 0
    // 1 0 1 1 | 0
    // 1 1 0 0 | 0
    // 1 1 0 1 | 1
    // 1 1 1 0 | 0
    // 1 1 1 1 | 1

    logic out_val;
    always @(*) begin
        case ({a, b, c, d})
            4'b0000: out_val = 1;
            4'b0001: out_val = 1;
            4'b0010: out_val = 1;
            4'b0011: out_val = 0;
            4'b0100: out_val = 1;
            4'b0101: out_val = 0;
            4'b0110: out_val = 1;
            4'b0111: out_val = 1;
            4'b1000: out_val = 1;
            4'b1001: out_val = 1;
            4'b1010: out_val = 0;
            4'b1011: out_val = 0;
            4'b1100: out_val = 0;
            4'b1101: out_val = 1;
            4'b1110: out_val = 0;
            4'b1111: out_val = 1;
            default: out_val = 0;
        endcase
    end
    assign out = out_val;
endmodule
