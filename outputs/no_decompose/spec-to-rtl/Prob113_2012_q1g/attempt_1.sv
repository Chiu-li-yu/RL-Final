module TopModule (
    input [3:0] x,
    output f
);
    // K-map layout:
    // x = {x[2], x[3], x[0], x[1]} (rows: x[2]x[3], cols: x[0]x[1])
    // The Karnaugh map provided:
    // x[2]x[3] \ x[0]x[1] | 00 | 01 | 11 | 10
    // ----------------------------------------
    // 00                  | 1  | 0  | 0  | 1
    // 01                  | 0  | 0  | 0  | 0
    // 11                  | 1  | 1  | 1  | 0
    // 10                  | 1  | 1  | 0  | 1

    // Map:
    // m(0)=1, m(1)=0, m(3)=0, m(2)=1  => row 00: 1001
    // m(4)=0, m(5)=0, m(7)=0, m(6)=0  => row 01: 0000
    // m(12)=1, m(13)=1, m(15)=1, m(14)=0 => row 11: 1110
    // m(8)=1, m(9)=1, m(11)=0, m(10)=1 => row 10: 1101

    // Minimized Expression:
    // f = (~x[2] & ~x[3] & ~x[1]) | (~x[3] & ~x[0] & ~x[1]) | ... wait let's use sum of products directly
    // Values where f=1: 0, 2, 8, 9, 10, 12, 13, 15
    // Binary:
    // 0000, 0010, 1000, 1001, 1010, 1100, 1101, 1111

    logic f_val;
    always @(*) begin
        case (x)
            4'b0000: f_val = 1'b1;
            4'b0010: f_val = 1'b1;
            4'b1000: f_val = 1'b1;
            4'b1001: f_val = 1'b1;
            4'b1010: f_val = 1'b1;
            4'b1100: f_val = 1'b1;
            4'b1101: f_val = 1'b1;
            4'b1111: f_val = 1'b1;
            default: f_val = 1'b0;
        endcase
    end

    assign f = f_val;
endmodule
