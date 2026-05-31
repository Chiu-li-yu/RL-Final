module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);

    // Let's re-read the K-Map exactly as written:
    //               ab
    //    cd   00  01  10  11
    //    00 | d | 0 | 1 | 1 |
    //    01 | 0 | 0 | d | d |
    //    11 | 0 | 1 | 1 | 1 |
    //    10 | 0 | 1 | 1 | 1 |
    
    // Mapping:
    // (a,b,c,d)
    // 0000: d(1) -> 1
    // 0100: 0
    // 1000: 1
    // 1100: 1
    
    // 0001: 0
    // 0101: 0
    // 1001: d(1) -> 1
    // 1101: d(1) -> 1
    
    // 0011: 0
    // 0111: 1
    // 1011: 1
    // 1111: 1
    
    // 0010: 0
    // 0110: 1
    // 1010: 1
    // 1110: 1
    
    // Logic:
    // out = 1 if:
    // (a=1) OR (b=1 AND c=1) OR (a=0 AND b=0 AND c=0 AND d=0)
    // Actually, looking at the 0s:
    // 0001, 0101, 0011, 0010 are 0.
    // Let's try: out = a | (b & c) | (~a & ~b & ~c & ~d)
    
    always @(*) begin
        out = a | (b & c) | (~a & ~b & ~c & ~d);
    end

endmodule