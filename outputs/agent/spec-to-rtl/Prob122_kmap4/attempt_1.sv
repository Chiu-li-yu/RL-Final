module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);
    // K-map table:
    //      ab
    // cd  00 01 11 10
    // 00 | 0| 1| 0| 1|
    // 01 | 1| 0| 1| 0|
    // 11 | 0| 1| 0| 1|
    // 10 | 1| 0| 1| 0|
    
    // Analyzing the K-map:
    // Out is 1 when:
    // (ab=00, cd=01) -> !a & !b & !c &  d
    // (ab=00, cd=10) -> !a & !b &  c & !d
    // (ab=01, cd=00) -> !a &  b & !c & !d
    // (ab=01, cd=11) -> !a &  b &  c &  d
    // (ab=11, cd=01) ->  a &  b & !c &  d
    // (ab=11, cd=10) ->  a &  b &  c & !d
    // (ab=10, cd=00) ->  a & !b & !c & !d
    // (ab=10, cd=11) ->  a & !b &  c &  d

    // This is equivalent to an XOR operation between (a^b) and (c^d).
    // Let's verify:
    // a^b: 00=0, 01=1, 11=0, 10=1
    // c^d: 00=0, 01=1, 11=0, 10=1
    // (a^b) ^ (c^d):
    // 00,00 -> 0^0 = 0
    // 00,01 -> 0^1 = 1
    // 00,11 -> 0^0 = 0
    // 00,10 -> 0^1 = 1
    // 01,00 -> 1^0 = 1
    // 01,01 -> 1^1 = 0
    // ... matches perfectly.

    always @(*) begin
        out = (a ^ b) ^ (c ^ d);
    end
endmodule
