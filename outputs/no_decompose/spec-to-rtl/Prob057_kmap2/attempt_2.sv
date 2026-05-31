module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map table interpretation:
    //      ab
    // cd  00 01 11 10
    // 00 | 1 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 0 | 1 |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 1 | 1 | 0 | 0 |
    
    // Truth Table:
    // (a,b,c,d) -> out
    // 0000 -> 1
    // 0100 -> 1
    // 1100 -> 0
    // 1000 -> 1
    // 0001 -> 1
    // 0101 -> 0
    // 1101 -> 0
    // 1001 -> 1
    // 0011 -> 0
    // 0111 -> 1
    // 1111 -> 1
    // 1011 -> 1
    // 0010 -> 1
    // 0110 -> 1
    // 1110 -> 0
    // 1010 -> 0

    logic out_logic;
    always @(*) begin
        case({a, b, c, d})
            4'b0000: out_logic = 1;
            4'b0001: out_logic = 1;
            4'b0010: out_logic = 1;
            4'b0011: out_logic = 0;
            4'b0100: out_logic = 1;
            4'b0101: out_logic = 0;
            4'b0110: out_logic = 1;
            4'b0111: out_logic = 1;
            4'b1000: out_logic = 1;
            4'b1001: out_logic = 1;
            4'b1010: out_logic = 0;
            4'b1011: out_logic = 1;
            4'b1100: out_logic = 0;
            4'b1101: out_logic = 0;
            4'b1110: out_logic = 0;
            4'b1111: out_logic = 1;
            default: out_logic = 0;
        endcase
    end
    assign out = out_logic;
endmodule
