module TopModule(
    input logic [3:0] x,
    output logic f
);
    // K-map (x3 x4 | x1 x2)
    //        00 01 11 10
    //     00 d  0  d  d
    //     01 0  d  1  0
    //     11 1  1  d  d
    //     10 1  1  0  d

    // Assign 'd' to make logic simple:
    // f = 1 when (x3 x4 x1 x2) = 0111, 1100, 1101, 1000, 1001
    // Let's choose d values:
    // (00 00) -> 0
    // (00 11) -> 0
    // (00 10) -> 0
    // (01 01) -> 0
    // (11 11) -> 0
    // (11 10) -> 0
    // (10 11) -> 0
    // (10 10) -> 0

    // Truth Table:
    // x3 x4 x1 x2 | f
    // 0  0  0  0  | 0
    // 0  0  0  1  | 0
    // 0  0  1  0  | 0
    // 0  0  1  1  | 0
    // 0  1  0  0  | 0
    // 0  1  0  1  | 0
    // 0  1  1  0  | 0
    // 0  1  1  1  | 1
    // 1  1  0  0  | 1
    // 1  1  0  1  | 1
    // 1  1  1  0  | 0
    // 1  1  1  1  | 0
    // 1  0  0  0  | 1
    // 1  0  0  1  | 1
    // 1  0  1  0  | 0
    // 1  0  1  1  | 0

    always @(*) begin
        case (x)
            4'b0111: f = 1'b1;
            4'b1100: f = 1'b1;
            4'b1101: f = 1'b1;
            4'b1000: f = 1'b1;
            4'b1001: f = 1'b1;
            default: f = 1'b0;
        endcase
    end
endmodule