module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out
);
    // K-map table (row cd, col ab):
    //    ab | 00 | 01 | 11 | 10
    // cd -----------------------
    // 00 | 0  | d  | 1  | 1
    // 01 | 0  | 0  | d  | d
    // 11 | 1  | 0  | 1  | 1
    // 10 | 1  | 0  | 1  | 1
    //
    // Truth table:
    // a b c d | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | 0
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    // 0 1 0 0 | d(0)
    // 0 1 0 1 | 0
    // 0 1 1 0 | 0
    // 0 1 1 1 | 0
    // 1 0 0 0 | 1
    // 1 0 0 1 | d(1)
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 1
    // 1 1 0 1 | d(1)
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1

    always @(*) begin
        // Simplification:
        // out = a | (~b & c) ?
        // 0000 -> 0 (0 | 0 = 0) OK
        // 0010 -> 1 (0 | 1 = 1) OK
        // 0100 -> 0 (0 | 0 = 0) OK
        // 1000 -> 1 (1 | 0 = 1) OK
        // 1100 -> 1 (1 | 0 = 1) OK
        // 0110 -> 0 (0 | 0 = 0) OK
        // 1111 -> 1 (1 | 0 = 1) OK
        
        out = a | (~b & c);
    end
endmodule
