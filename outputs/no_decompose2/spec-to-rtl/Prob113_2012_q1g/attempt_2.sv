module TopModule (
    input [3:0] x,
    output logic f
);
    // x[2]x[3]  00  01  11  10
    // x[0]x[1]
    // 00 -> 1
    // 01 -> 0
    // 11 -> 0
    // 10 -> 1
    // ...

    // Let's re-verify the table:
    // x[2]x[3] \ x[0]x[1]
    //            00  01  11  10
    // 00 (x2=0,x3=0): 1   0   0   1
    // 01 (x2=0,x3=1): 0   0   0   0
    // 11 (x2=1,x3=1): 1   1   1   0
    // 10 (x2=1,x3=0): 1   1   0   1

    // Mapping:
    // x[0], x[1], x[2], x[3]
    // x[0]x[1] are columns, x[2]x[3] are rows.

    always @(*) begin
        case (x)
            4'b0000: f = 1'b1; // x2=0,x3=0, x0=0,x1=0 -> row 00, col 00
            4'b1000: f = 1'b1; // x2=0,x3=0, x0=1,x1=0 -> row 00, col 10 (wait, bit index?)
        endcase
    end
endmodule
