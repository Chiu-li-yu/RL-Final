module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Let's re-read the Karnaugh map one last time, very carefully:
    // Columns are ab: 00, 01, 11, 10
    // Rows are cd: 00, 01, 11, 10
    
    // Rows (cd) map to:
    // 00: cd = 00
    // 01: cd = 01
    // 11: cd = 11
    // 10: cd = 10
    
    // (a, b) | (c, d)
    // 0, 0   | 0, 0: 1 | 0, 1: 1 | 1, 1: 0 | 1, 0: 1
    // 0, 1   | 0, 0: 1 | 0, 1: 0 | 1, 1: 1 | 1, 0: 1
    // 1, 1   | 0, 0: 0 | 0, 1: 1 | 1, 1: 1 | 1, 0: 1
    // 1, 0   | 0, 0: 1 | 0, 1: 1 | 1, 1: 0 | 1, 0: 0
    
    // Let's build the truth table again:
    // abcd | out
    // 0000 | 1
    // 0001 | 1
    // 0010 | 1
    // 0011 | 0
    // 0100 | 1
    // 0101 | 0
    // 0110 | 1
    // 0111 | 1
    // 1100 | 0
    // 1101 | 1
    // 1110 | 1
    // 1111 | 1
    // 1000 | 1
    // 1001 | 1
    // 1010 | 0
    // 1011 | 0
    
    logic out_val;
    always @(*) begin
        case ({a, b, c, d})
            4'b0000: out_val = 1;
            4'b0001: out_val = 1;
            4'b0010: out_val = 1;
            4'b0011: out_val = 0;
            4'b0100: out_val = 1;
            4'b0101: out_val = 0;
            4'b0110: out_val = 1;
            4'b0111: out_val = 1;
            4'b1100: out_val = 0;
            4'b1101: out_val = 1;
            4'b1110: out_val = 1;
            4'b1111: out_val = 1;
            4'b1000: out_val = 1;
            4'b1001: out_val = 1;
            4'b1010: out_val = 0;
            4'b1011: out_val = 0;
            default: out_val = 0;
        endcase
    end
    assign out = out_val;
endmodule
