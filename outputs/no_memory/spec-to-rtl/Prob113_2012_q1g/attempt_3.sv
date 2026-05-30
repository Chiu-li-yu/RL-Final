module TopModule(
    input [3:0] x,
    output f
);
    // x = {x[2], x[3], x[0], x[1]} mapping based on problem:
    // Rows: x[2]x[3], Cols: x[0]x[1]
    // Values:
    // 0000 -> 1, 0001 -> 0, 0011 -> 0, 0010 -> 1
    // 0100 -> 0, 0101 -> 0, 0111 -> 0, 0110 -> 0
    // 1100 -> 1, 1101 -> 1, 1111 -> 1, 1110 -> 0
    // 1000 -> 1, 1001 -> 1, 1011 -> 0, 1010 -> 1
    
    // x[3], x[2], x[1], x[0]
    // Let's use case statement or logic
    logic f_int;
    always @(*) begin
        case(x)
            4'b0000: f_int = 1;
            4'b0001: f_int = 0;
            4'b0011: f_int = 0;
            4'b0010: f_int = 1;
            4'b0100: f_int = 0;
            4'b0101: f_int = 0;
            4'b0111: f_int = 0;
            4'b0110: f_int = 0;
            4'b1100: f_int = 1;
            4'b1101: f_int = 1;
            4'b1111: f_int = 1;
            4'b1110: f_int = 0;
            4'b1000: f_int = 1;
            4'b1001: f_int = 1;
            4'b1011: f_int = 0;
            4'b1010: f_int = 1;
            default: f_int = 0;
        endcase
    end
    assign f = f_int;
endmodule