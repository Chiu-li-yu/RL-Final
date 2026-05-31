module TopModule (
    input [3:0] x,
    output f
);
    // K-map layout:
    // Row (x[2]x[3]): 00, 01, 11, 10
    // Col (x[0]x[1]): 00, 01, 11, 10
    // Value:
    //      00 01 11 10
    // 00:  1  0  0  1
    // 01:  0  0  0  0
    // 11:  1  1  1  0
    // 10:  1  1  0  1

    // Mapping:
    // Minterms:
    // (x[2], x[3], x[0], x[1])
    // (0,0,0,0) -> 1
    // (0,0,1,0) -> 1
    // (1,1,0,0) -> 1
    // (1,1,0,1) -> 1
    // (1,1,1,1) -> 1
    // (1,0,0,0) -> 1
    // (1,0,0,1) -> 1
    // (1,0,1,0) -> 1

    logic f_tmp;
    always @(*) begin
        case (x)
            4'b0000: f_tmp = 1;
            4'b0010: f_tmp = 1;
            4'b1100: f_tmp = 1;
            4'b1101: f_tmp = 1;
            4'b1111: f_tmp = 1;
            4'b1000: f_tmp = 1;
            4'b1001: f_tmp = 1;
            4'b1010: f_tmp = 1;
            default: f_tmp = 0;
        endcase
    end
    assign f = f_tmp;
endmodule
