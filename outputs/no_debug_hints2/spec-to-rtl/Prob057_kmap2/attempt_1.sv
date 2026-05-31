module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // K-map breakdown:
    // a b c d | out
    // 0 0 0 0 | 1
    // 0 0 0 1 | 1
    // 0 0 1 0 | 1
    // 0 0 1 1 | 0
    // 0 1 0 0 | 1
    // 0 1 0 1 | 0
    // 0 1 1 0 | 1
    // 0 1 1 1 | 1
    // 1 0 0 0 | 1
    // 1 0 0 1 | 1
    // 1 0 1 0 | 0
    // 1 0 1 1 | 1
    // 1 1 0 0 | 0
    // 1 1 0 1 | 0
    // 1 1 1 0 | 0
    // 1 1 1 1 | 1
    
    // Derived logical expression using SOP or K-map simplification:
    // Simplified logic:
    // out = (~a & ~b & ~c) | (~a & ~c & ~d) | (~a & b & c) | (a & ~b & ~d) | (a & b & c & d) | (~b & ~c & ~d)
    // Actually, let's just use a case statement for simplicity and correctness.
    
    logic out_reg;
    always @(*) begin
        case ({a, b, c, d})
            4'b0000: out_reg = 1;
            4'b0001: out_reg = 1;
            4'b0010: out_reg = 1;
            4'b0011: out_reg = 0;
            4'b0100: out_reg = 1;
            4'b0101: out_reg = 0;
            4'b0110: out_reg = 1;
            4'b0111: out_reg = 1;
            4'b1000: out_reg = 1;
            4'b1001: out_reg = 1;
            4'b1010: out_reg = 0;
            4'b1011: out_reg = 1;
            4'b1100: out_reg = 0;
            4'b1101: out_reg = 0;
            4'b1110: out_reg = 0;
            4'b1111: out_reg = 1;
            default: out_reg = 0;
        endcase
    end
    
    assign out = out_reg;
endmodule
