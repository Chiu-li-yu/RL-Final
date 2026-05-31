module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map:
    //      ab
    // cd  00 01 10 11
    // 00  0  d  1  1
    // 01  0  0  d  d
    // 11  1  0  1  1
    // 10  1  0  1  1

    // Let's set 'd' to minimize logic:
    // (ab, cd)
    // 00,00 -> 0
    // 01,00 -> 0 (d=0)
    // 10,00 -> 1
    // 11,00 -> 1
    // 00,01 -> 0
    // 01,01 -> 0
    // 10,01 -> 1 (d=1)
    // 11,01 -> 1 (d=1)
    // 00,11 -> 1
    // 01,11 -> 0
    // 10,11 -> 1
    // 11,11 -> 1
    // 00,10 -> 1
    // 01,10 -> 0
    // 10,10 -> 1
    // 11,10 -> 1

    // Logical expression derived:
    // out = a | (~c & b) ... wait, let's simplify properly.
    // The columns are (00, 01, 11, 10)
    // The rows are (00, 01, 11, 10)
    // Actually, simple way: out = a | (~c & b) is probably wrong.
    // Let's just use a truth table assignment for safety.
    
    logic out_logic;
    always @(*) begin
        case ({a, b, c, d})
            4'b0000: out_logic = 0;
            4'b0001: out_logic = 0;
            4'b0010: out_logic = 1;
            4'b0011: out_logic = 1;
            4'b0100: out_logic = 0;
            4'b0101: out_logic = 0;
            4'b0110: out_logic = 0;
            4'b0111: out_logic = 0;
            4'b1000: out_logic = 1;
            4'b1001: out_logic = 1;
            4'b1010: out_logic = 1;
            4'b1011: out_logic = 1;
            4'b1100: out_logic = 1;
            4'b1101: out_logic = 1;
            4'b1110: out_logic = 1;
            4'b1111: out_logic = 1;
            default: out_logic = 0;
        endcase
    end
    assign out = out_logic;
endmodule