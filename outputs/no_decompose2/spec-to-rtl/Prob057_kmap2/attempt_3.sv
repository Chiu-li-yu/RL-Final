module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Let's re-read the K-map carefully:
    //      ab
    // cd  00 01 11 10
    // 00 | 1 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 0 | 1 |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 1 | 1 | 0 | 0 |

    // Wait, the K-map index order might be unusual.
    // Standard K-map ab: 00, 01, 11, 10
    // Standard K-map cd: 00, 01, 11, 10 (Gray code)
    
    // Map values:
    // a b c d | out
    // 0 0 0 0 | 1
    // 0 0 0 1 | 1
    // 0 0 1 1 | 0  <-- cd = 11, ab = 00
    // 0 0 1 0 | 1  <-- cd = 10, ab = 00
    
    // Let's map it based on (a, b) columns and (c, d) rows:
    // (a,b) = 00, 01, 11, 10
    // (c,d) = 00, 01, 11, 10
    
    // Row 0 (cd=00): ab=00->1, 01->1, 11->0, 10->1  => 4'b1101
    // Row 1 (cd=01): ab=00->1, 01->0, 11->0, 10->1  => 4'b1001
    // Row 2 (cd=11): ab=00->0, 01->1, 11->1, 10->1  => 4'b0111
    // Row 3 (cd=10): ab=00->1, 01->1, 11->0, 10->0  => 4'b1100

    // a=0, b=0, c=0, d=0 (cd=00, ab=00) -> 1
    // a=0, b=1, c=0, d=0 (cd=00, ab=01) -> 1
    // a=1, b=1, c=0, d=0 (cd=00, ab=11) -> 0
    // a=1, b=0, c=0, d=0 (cd=00, ab=10) -> 1
    
    // a=0, b=0, c=0, d=1 (cd=01, ab=00) -> 1
    // a=0, b=1, c=0, d=1 (cd=01, ab=01) -> 0
    // a=1, b=1, c=0, d=1 (cd=01, ab=11) -> 0
    // a=1, b=0, c=0, d=1 (cd=01, ab=10) -> 1
    
    // a=0, b=0, c=1, d=1 (cd=11, ab=00) -> 0
    // a=0, b=1, c=1, d=1 (cd=11, ab=01) -> 1
    // a=1, b=1, c=1, d=1 (cd=11, ab=11) -> 1
    // a=1, b=0, c=1, d=1 (cd=11, ab=10) -> 1
    
    // a=0, b=0, c=1, d=0 (cd=10, ab=00) -> 1
    // a=0, b=1, c=1, d=0 (cd=10, ab=01) -> 1
    // a=1, b=1, c=1, d=0 (cd=10, ab=11) -> 0
    // a=1, b=0, c=1, d=0 (cd=10, ab=10) -> 0
    
    // Re-check:
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
    // 1 0 1 1 | 1
    // 1 1 0 0 | 0
    // 1 1 0 1 | 0
    // 1 1 1 0 | 0
    // 1 1 1 1 | 1
    
    // This looks much more consistent. Let's try this table.

    logic out_logic;
    always @(*) begin
        case ({a, b, c, d})
            4'b0000: out_logic = 1;
            4'b0001: out_logic = 1;
            4'b0010: out_logic = 1;
            4'b0011: out_logic = 0;
            4'b0100: out_logic = 1;
            4'b0101: out_logic = 0;
            4'b0110: out_logic = 1;
            4'b0111: out_logic = 1;
            4'b1000: out_logic = 1;
            4'b1001: out_logic = 1;
            4'b1010: out_logic = 0;
            4'b1011: out_logic = 1;
            4'b1100: out_logic = 0;
            4'b1101: out_logic = 0;
            4'b1110: out_logic = 0;
            4'b1111: out_logic = 1;
        endcase
    end
    assign out = out_logic;
endmodule
