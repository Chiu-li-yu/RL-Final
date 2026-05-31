module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);
    // K-map table construction:
    // (ab, cd) | out
    // 00, 00: 1
    // 00, 01: 1
    // 00, 10: 1
    // 00, 11: 0
    // 01, 00: 1
    // 01, 01: 0
    // 01, 10: 1
    // 01, 11: 1
    // 10, 00: 1
    // 10, 01: 1
    // 10, 10: 0
    // 10, 11: 1
    // 11, 00: 0
    // 11, 01: 0
    // 11, 10: 0
    // 11, 11: 1

    always @(*) begin
        // Use case logic based on the K-map values (1s)
        case({a, b, c, d})
            4'b0000: out = 1;
            4'b0001: out = 1;
            4'b0010: out = 1;
            4'b0011: out = 0;
            4'b0100: out = 1;
            4'b0101: out = 0;
            4'b0110: out = 1;
            4'b0111: out = 1;
            4'b1000: out = 1;
            4'b1001: out = 1;
            4'b1010: out = 0;
            4'b1011: out = 1;
            4'b1100: out = 0;
            4'b1101: out = 0;
            4'b1110: out = 0;
            4'b1111: out = 1;
            default: out = 0;
        endcase
    end
endmodule
