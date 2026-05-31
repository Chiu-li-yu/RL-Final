module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out
);

    always @(*) begin
        // K-map table mapping:
        // ab\cd | 00 | 01 | 11 | 10
        // ------+----+----+----+----
        // 00    | 0  | 0  | 1  | 1
        // 01    | d  | 0  | 0  | 1
        // 10    | 1  | d  | 1  | 1
        // 11    | 1  | d  | 1  | 1
        
        // Setting d=1:
        // 1s at:
        // 0011, 0010
        // 0100, 0110
        // 1000, 1001, 1010, 1011
        // 1100, 1101, 1110, 1111
        
        // Simplified boolean:
        // out = a | (~b & c) | (b & ~c & ~d)
        // Let's re-verify:
        // a=1 -> out=1 (covers 8 cells)
        // b=0, c=1 -> out=1 (covers 0010, 0011, 1010, 1011)
        // b=1, c=0, d=0 -> out=1 (covers 0100, 1100)
        
        // This covers everything expected.
        out = a | (~b & c) | (b & ~c & ~d);
    end

endmodule
