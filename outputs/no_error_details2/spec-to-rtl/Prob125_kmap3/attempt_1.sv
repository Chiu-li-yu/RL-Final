module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);

    // K-map translation:
    // Row 1 (c=0, d=0): ab=00:0, 01:d, 10:1, 11:1
    // Row 2 (c=0, d=1): ab=00:0, 01:0, 10:d, 11:d
    // Row 3 (c=1, d=1): ab=00:0, 01:1, 10:1, 11:1
    // Row 4 (c=1, d=0): ab=00:0, 01:1, 10:1, 11:1
    
    // We have:
    // (a,b,c,d) | out
    // 0000 | 0
    // 0001 | 0
    // 0010 | 0
    // 0011 | 0
    // 0100 | 0
    // 0101 | 0
    // 0110 | 1
    // 0111 | 1
    // 1000 | 1
    // 1001 | d (let's pick 1)
    // 1010 | 1
    // 1011 | 1
    // 1100 | 1
    // 1101 | d (let's pick 1)
    // 1110 | 1
    // 1111 | 1

    // Mapping:
    // 0000: 0
    // 0001: 0
    // 0010: 0
    // 0011: 0
    // 0100: 0
    // 0101: 0
    // 0110: 1
    // 0111: 1
    // 1000: 1
    // 1001: 1
    // 1010: 1
    // 1011: 1
    // 1100: 1
    // 1101: 1
    // 1110: 1
    // 1111: 1

    // Simplified Logic:
    // Out is 1 when (a=1) OR (c=1 AND b=1)
    // Verify:
    // 1000: a=1, out=1 (True)
    // 0110: a=0, b=1, c=1, out=1 (True)
    // 0000: a=0, b=0, c=0, out=0 (True)
    
    always @(*) begin
        out = a | (b & c);
    end

endmodule