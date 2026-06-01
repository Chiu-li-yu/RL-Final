module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // K-map (cd as rows, ab as cols):
    //      01 00 10 11
    // 00 | d | 0 | 1 | 1 |
    // 01 | 0 | 0 | d | d |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 0 | 1 | 1 | 1 |
    
    // Truth table analysis (c,d,a,b):
    // 0000 -> 0
    // 0001 -> 0 (d=0)
    // 0010 -> 1
    // 0011 -> 1
    // 0100 -> 0
    // 0101 -> 0
    // 0110 -> 0 (d=0)
    // 0111 -> 0 (d=0)
    // 1000 -> 1
    // 1001 -> 0
    // 1010 -> 1
    // 1011 -> 1
    // 1100 -> 1
    // 1101 -> 0
    // 1110 -> 1
    // 1111 -> 1
    
    // Simplification (using K-map):
    // Output is 1 when:
    // (a=1, b=0) -> always 1
    // (a=1, b=1) -> always 1
    // (c=1, d=0, a=0, b=0) -> 1
    // (c=1, d=1, a=0, b=0) -> 1
    // -> simplified: a | (~c & ~a & ~b) is not quite right...
    // Let's re-group:
    // a | (~a & ~b & ~c) | (~a & ~b & ~d) ??
    // Let's try: out = a | (~b & ~c) | (~b & ~d) ? No.
    // Let's use simple logic: out = a | (~b & ~c & ~d) | (~b & c & ~d) ...
    
    // Actually, looking at the map:
    // Row 00: 0, 0, 1, 1 (ab: 00, 01, 10, 11)
    // Row 01: 0, 0, 0, 0 (ab: 00, 01, 10, 11)  <- treated d as 0
    // Row 11: 1, 0, 1, 1 (ab: 00, 01, 10, 11)
    // Row 10: 1, 0, 1, 1 (ab: 00, 01, 10, 11)
    
    // out = a | (~b & ~c & ~d) | (~b & c & ~d) ?
    // Simplifies to a | (~b & ~d).
    // Let's check a | (~b & ~d):
    // a=0, b=0, c=0, d=0 -> 1 (Map: 0, expected 1) - Wait, map says 0 for (ab=00, cd=00)
    // My K-map reading might be off.
    
    // Let's re-read carefully:
    // ab = 00 -> Col 2
    // ab = 01 -> Col 1
    // ab = 10 -> Col 3
    // ab = 11 -> Col 4
    
    // Row 00 (c=0, d=0): Col1(01)=d, Col2(00)=0, Col3(10)=1, Col4(11)=1
    // Row 01 (c=0, d=1): Col1(01)=0, Col2(00)=0, Col3(10)=d, Col4(11)=d
    // Row 11 (c=1, d=1): Col1(01)=0, Col2(00)=1, Col3(10)=1, Col4(11)=1
    // Row 10 (c=1, d=0): Col1(01)=0, Col2(00)=1, Col3(10)=1, Col4(11)=1
    
    always @(*) begin
        out = a | (c & ~b);
    end
endmodule