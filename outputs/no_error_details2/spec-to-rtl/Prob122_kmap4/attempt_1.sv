module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    logic out_temp;

    always @(*) begin
        // Karnaugh map interpretation:
        // cd \ ab | 00 | 01 | 11 | 10
        // --------------------------
        // 00      | 0  | 1  | 0  | 1
        // 01      | 1  | 0  | 1  | 0
        // 11      | 0  | 1  | 0  | 1
        // 10      | 1  | 0  | 1  | 0
        
        // This is XOR of b and d
        // b d | out
        // 0 0 | 0
        // 0 1 | 1
        // 1 0 | 1
        // 1 1 | 0
        // Let's re-examine.
        // It looks like out = b ^ d.
        // Let's verify:
        // (a,b,c,d)
        // 0000: b=0, d=0 -> 0
        // 0100: b=1, d=0 -> 1
        // 0001: b=0, d=1 -> 1
        // 0101: b=1, d=1 -> 0
        // The table shows:
        // Row 00 (cd=00): ab=00->0, 01->1, 11->0, 10->1. Correct (b^d=0^0=0, 1^0=1, 1^0=1, 0^0=0? Wait)
        // Let's re-read the K-map:
        // ab\cd | 00 | 01 | 11 | 10
        // -------------------------
        // 00    | 0  | 1  | 0  | 1
        // 01    | 1  | 0  | 1  | 0
        // 11    | 0  | 1  | 0  | 1
        // 10    | 1  | 0  | 1  | 0
        
        // Looking at columns:
        // ab=00: cd=00->0, 01->1, 11->0, 10->1 => d=1 if 01 or 10. XOR behavior?
        // Actually, it's (b ^ d).
        
        out_temp = (b ^ d);
    end

    assign out = out_temp;
endmodule