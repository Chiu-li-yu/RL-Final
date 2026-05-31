module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Karnaugh Map analysis:
    // a=0, bc=00 -> 0
    // a=0, bc=01 -> 1
    // a=0, bc=11 -> 1
    // a=0, bc=10 -> 1
    // a=1, bc=00 -> 1
    // a=1, bc=01 -> 1
    // a=1, bc=11 -> 1
    // a=1, bc=10 -> 1
    //
    // Simplified expression:
    // Out = a + (b | c)
    // Proof:
    // If a=1: always 1
    // If a=0: Out = b | c
    // Check:
    // 000: 0 | 0 = 0 (Matches)
    // 001: 0 | 1 = 1 (Matches)
    // 011: 1 | 1 = 1 (Matches)
    // 010: 1 | 0 = 1 (Matches)
    // All 1s for a=1 (Matches)

    always @(*) begin
        out = a | (b | c);
    end
endmodule
