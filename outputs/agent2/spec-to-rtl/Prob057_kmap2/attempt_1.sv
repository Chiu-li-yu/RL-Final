module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // K-map:
    //      ab
    // cd  00 01 11 10
    // 00 | 1 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 0 | 1 |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 1 | 1 | 0 | 0 |
    //
    // Minimized expression:
    // Grouping 1s:
    // (a'b'c') + (a'd') + (b'c'd) + (abc) + (ac'd') + (abd')
    // Wait, let's look at the K-map again.
    //
    // 1s at positions (c d a b):
    // 0 0 0 0 -> 1
    // 0 0 0 1 -> 1
    // 0 0 1 0 -> 1
    // 0 1 0 0 -> 1
    // 0 1 1 0 -> 1
    // 1 1 0 1 -> 1
    // 1 1 1 1 -> 1
    // 1 1 1 0 -> 1
    // 1 0 0 0 -> 1
    // 1 0 0 1 -> 1
    
    // Truth Table:
    // c d a b | out
    // 0 0 0 0 | 1
    // 0 0 0 1 | 1
    // 0 0 1 0 | 1
    // 0 0 1 1 | 0
    // 0 1 0 0 | 1
    // 0 1 0 1 | 0
    // 0 1 1 0 | 0
    // 0 1 1 1 | 1
    // 1 0 0 0 | 1
    // 1 0 0 1 | 1
    // 1 0 1 0 | 0
    // 1 0 1 1 | 1
    // 1 1 0 0 | 0
    // 1 1 0 1 | 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1

    logic out_temp;
    always @(*) begin
        case ({c, d, a, b})
            4'b0000: out_temp = 1;
            4'b0001: out_temp = 1;
            4'b0010: out_temp = 1;
            4'b0011: out_temp = 0;
            4'b0100: out_temp = 1;
            4'b0101: out_temp = 0;
            4'b0110: out_temp = 0;
            4'b0111: out_temp = 1;
            4'b1000: out_temp = 1;
            4'b1001: out_temp = 1;
            4'b1010: out_temp = 0;
            4'b1011: out_temp = 1;
            4'b1100: out_temp = 0;
            4'b1101: out_temp = 1;
            4'b1110: out_temp = 1;
            4'b1111: out_temp = 1;
            default: out_temp = 0;
        endcase
    end
    assign out = out_temp;

endmodule
