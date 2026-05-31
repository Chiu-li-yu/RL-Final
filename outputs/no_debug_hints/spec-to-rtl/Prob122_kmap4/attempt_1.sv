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
    
    // Pattern observed:
    // out = 1 when:
    // (a=0, b=0, c=0, d=1) -> 0001
    // (a=0, b=0, c=1, d=0) -> 0010
    // (a=0, b=1, c=0, d=0) -> 0100
    // (a=0, b=1, c=1, d=1) -> 0111
    // ... wait, let's look at XOR pattern
    // The table looks like XOR of all inputs: a ^ b ^ c ^ d
    // Let's verify:
    // a b c d | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | 1
    // 0 0 1 0 | 1
    // 0 0 1 1 | 0
    // 0 1 0 0 | 1
    // 0 1 0 1 | 0
    // 0 1 1 0 | 0
    // 0 1 1 1 | 1
    // ...
    // Looking at the K-map:
    // ab=00, cd=01 (0,0,0,1) -> 1
    // ab=00, cd=10 (0,0,1,0) -> 1
    // ab=01, cd=00 (0,1,0,0) -> 1
    // ab=01, cd=11 (0,1,1,1) -> 1
    // ab=11, cd=01 (1,1,0,1) -> 1
    // ab=11, cd=10 (1,1,1,0) -> 1
    // ab=10, cd=00 (1,0,0,0) -> 1
    // ab=10, cd=11 (1,0,1,1) -> 1
    
    // Check parity:
    // 0001 (sum=1, odd)
    // 0010 (sum=1, odd)
    // 0100 (sum=1, odd)
    // 0111 (sum=3, odd)
    // 1101 (sum=3, odd)
    // 1110 (sum=3, odd)
    // 1000 (sum=1, odd)
    // 1011 (sum=3, odd)
    // Yes, it is the parity function: a ^ b ^ c ^ d

    always @(*) begin
        out = a ^ b ^ c ^ d;
    end

endmodule