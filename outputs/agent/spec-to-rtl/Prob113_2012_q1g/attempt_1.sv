module TopModule (
    input [3:0] x,
    output f
);
    // x[2]x[3] x[0]x[1]
    // 00: 1 0 0 1
    // 01: 0 0 0 0
    // 11: 1 1 1 0
    // 10: 1 1 0 1

    // Map the Karnaugh map to index (x[2], x[3], x[0], x[1])
    // The input x is 4 bits: x[3], x[2], x[1], x[0]
    // The K-map order is:
    // Rows: x[2]x[3]
    // Cols: x[0]x[1]

    logic f_tmp;
    always @(*) begin
        case ({x[2], x[3], x[0], x[1]})
            4'b0000: f_tmp = 1;
            4'b0001: f_tmp = 0;
            4'b0011: f_tmp = 0;
            4'b0010: f_tmp = 1;
            4'b0100: f_tmp = 0;
            4'b0101: f_tmp = 0;
            4'b0111: f_tmp = 0;
            4'b0110: f_tmp = 0;
            4'b1100: f_tmp = 1;
            4'b1101: f_tmp = 1;
            4'b1111: f_tmp = 1;
            4'b1110: f_tmp = 0;
            4'b1000: f_tmp = 1;
            4'b1001: f_tmp = 1;
            4'b1011: f_tmp = 0;
            4'b1010: f_tmp = 1;
            default: f_tmp = 0;
        endcase
    end
    assign f = f_tmp;
endmodule
