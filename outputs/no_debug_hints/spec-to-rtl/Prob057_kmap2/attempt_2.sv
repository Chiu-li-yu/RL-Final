module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);

    // K-map Truth Table Analysis:
    // (ab, cd) -> out
    // 00, 00 -> 1
    // 00, 01 -> 1
    // 00, 10 -> 1
    // 00, 11 -> 0
    // 01, 00 -> 1
    // 01, 01 -> 0
    // 01, 10 -> 1
    // 01, 11 -> 1
    // 10, 00 -> 1
    // 10, 01 -> 1
    // 10, 10 -> 0
    // 10, 11 -> 1
    // 11, 00 -> 0
    // 11, 01 -> 0
    // 11, 10 -> 0
    // 11, 11 -> 1

    always @(*) begin
        out = (~a & ~b & ~c) | 
              (~b & ~c & ~d) | 
              (~a & b & c & d) | 
              (a & b & c & d) | 
              (~a & b & ~c & ~d) | 
              (a & ~b & ~c & ~d);
    end
endmodule
