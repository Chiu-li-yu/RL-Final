module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);

    // Re-Mapping the K-Map manually:
    // Columns (ab): 00, 01, 10, 11
    // Rows (cd):    00, 01, 11, 10
    
    // (a,b,c,d) -> out
    // 0000 -> 0 (from cd=00, ab=00)
    // 0001 -> 0 (from cd=01, ab=00)
    // 0011 -> 0 (from cd=11, ab=00)
    // 0010 -> 0 (from cd=10, ab=00)
    
    // 0100 -> 0 (from cd=00, ab=01)
    // 0101 -> 0 (from cd=01, ab=01)
    // 0111 -> 1 (from cd=11, ab=01)
    // 0110 -> 1 (from cd=10, ab=01)
    
    // 1000 -> 1 (from cd=00, ab=10)
    // 1001 -> d -> 1
    // 1011 -> 1 (from cd=11, ab=10)
    // 1010 -> 1 (from cd=10, ab=10)
    
    // 1100 -> 1 (from cd=00, ab=11)
    // 1101 -> d -> 1
    // 1111 -> 1 (from cd=11, ab=11)
    // 1110 -> 1 (from cd=10, ab=11)
    
    // Simplified logic:
    // out = 1 when (a=1) OR (b=1 AND c=1)
    
    // Wait, let's re-check the rows for (b=1, c=1):
    // If b=1, c=1:
    // Row 11 (c=1, d=1): ab=01(1), 11(1) -> 1.
    // Row 10 (c=1, d=0): ab=01(1), 11(1) -> 1.
    // This looks correct.
    
    // Let's re-check (a=1):
    // Row 00 (c=0, d=0): ab=10(1), 11(1) -> 1.
    // Row 01 (c=0, d=1): ab=10(d), 11(d) -> 1.
    // Row 11 (c=1, d=1): ab=10(1), 11(1) -> 1.
    // Row 10 (c=1, d=0): ab=10(1), 11(1) -> 1.
    // This also looks correct.
    
    // Therefore, out = a | (b & c). 
    // Let's test against all combinations:
    // a=0, b=0, c=0, d=0: 0 | (0&0) = 0 (Match)
    // a=0, b=1, c=1, d=0: 0 | (1&1) = 1 (Match)
    // a=1, b=0, c=0, d=0: 1 | (0&0) = 1 (Match)

    always @(*) begin
        out = a | (b & c);
    end

endmodule