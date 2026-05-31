module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out
);
    // K-map analysis:
    //    cd\ab 00  01  11  10
    //    00     0   1   0   1
    //    01     1   0   1   0
    //    11     0   1   0   1
    //    10     1   0   1   0
    //
    // The pattern is a checkerboard:
    // The output is 1 when (a^b^c^d) is 1?
    // Let's check:
    // 0000: 0^0^0^0 = 0 (Correct)
    // 0001: 0^0^0^1 = 1 (Correct)
    // 0010: 0^0^1^0 = 1 (Correct - wait, 0000 is 0, 0001 is 1, 0010 is 1. My manual K-map check:)
    // Wait, let's re-read the table:
    // cd=00: ab=01 (1), ab=10 (1) -> 0, 1, 0, 1
    // cd=01: ab=00 (1), ab=11 (1) -> 1, 0, 1, 0
    // cd=11: ab=01 (1), ab=10 (1) -> 0, 1, 0, 1
    // cd=10: ab=00 (1), ab=11 (1) -> 1, 0, 1, 0
    //
    // This looks like XOR operation.
    // out = a ^ b ^ c ^ d?
    // 0000: 0
    // 0001: 1
    // 0010: 1
    // 0011: 0
    // 0100: 1
    // 0101: 0
    // 0110: 0
    // 0111: 1
    // 1000: 1
    // 1001: 0
    // 1010: 0
    // 1011: 1
    // 1100: 0
    // 1101: 1
    // 1110: 1
    // 1111: 0
    //
    // Let's verify K-map provided:
    // (a,b,c,d)
    // 0000 (ab=00, cd=00): 0
    // 0100 (ab=01, cd=00): 1
    // 1100 (ab=11, cd=00): 0
    // 1000 (ab=10, cd=00): 1
    // Matches the first row (0, 1, 0, 1). Correct.

    always @(*) begin
        out = a ^ b ^ c ^ d;
    end
endmodule
