module TopModule (
    input [3:0] x,
    output f
);

    // x[2]x[3] (rows)
    // x[0]x[1] (cols)
    // Mapping:
    // x[3] is the second bit of row index
    // x[2] is the first bit of row index
    // x[1] is the second bit of col index
    // x[0] is the first bit of col index
    // But the K-map says x[2]x[3] is row index, x[0]x[1] is column index.
    // Let row_idx = {x[2], x[3]}
    // Let col_idx = {x[0], x[1]}
    
    // Truth table:
    // x[2]x[3] x[0]x[1] | f
    // 00       00       | 1
    // 00       01       | 0
    // 00       11       | 0
    // 00       10       | 1
    // 01       00       | 0
    // 01       01       | 0
    // 01       11       | 0
    // 01       10       | 0
    // 11       00       | 1
    // 11       01       | 1
    // 11       11       | 1
    // 11       10       | 0
    // 10       00       | 1
    // 10       01       | 1
    // 10       11       | 0
    // 10       10       | 1

    logic f_int;

    always @(*) begin
        case (x)
            4'b0000: f_int = 1'b1;
            4'b0001: f_int = 1'b0;
            4'b0011: f_int = 1'b0;
            4'b0010: f_int = 1'b1;
            4'b0100: f_int = 1'b0;
            4'b0101: f_int = 1'b0;
            4'b0111: f_int = 1'b0;
            4'b0110: f_int = 1'b0;
            4'b1100: f_int = 1'b1;
            4'b1101: f_int = 1'b1;
            4'b1111: f_int = 1'b1;
            4'b1110: f_int = 1'b0;
            4'b1000: f_int = 1'b1;
            4'b1001: f_int = 1'b1;
            4'b1011: f_int = 1'b0;
            4'b1010: f_int = 1'b1;
            default: f_int = 1'b0;
        endcase
    end

    assign f = f_int;

endmodule
