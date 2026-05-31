module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map table analysis:
    // ab \ cd | 00 | 01 | 11 | 10
    // ---------------------------
    // 00      | 0  | 1  | 0  | 1
    // 01      | 1  | 0  | 1  | 0
    // 11      | 0  | 1  | 0  | 1
    // 10      | 1  | 0  | 1  | 0
    //
    // The pattern is: out = a ^ b ^ c ^ d
    // Let's double check:
    // a=0, b=0, c=0, d=0 -> 0^0^0^0 = 0 (Matches)
    // a=0, b=0, c=0, d=1 -> 0^0^0^1 = 1 (Matches)
    // a=0, b=1, c=0, d=0 -> 0^1^0^0 = 1 (Matches)
    // a=1, b=1, c=1, d=1 -> 1^1^1^1 = 0 (Matches)
    // a=1, b=0, c=0, d=0 -> 1^0^0^0 = 1 (Matches)
    
    always @(*) begin
        out = a ^ b ^ c ^ d;
    end
endmodule
