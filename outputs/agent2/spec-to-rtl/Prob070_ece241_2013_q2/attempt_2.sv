module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Golden model using case statement
    logic out;
    always_comb begin
        case ({a, b, c, d})
            4'b0010, 4'b0111, 4'b1111: out = 1;
            4'b0000, 4'b0001, 4'b0100, 4'b0101, 4'b0110, 4'b1001, 4'b1010, 4'b1101, 4'b1110: out = 0;
            default: out = 1'bx;
        endcase
    end

    // SOP = a'b'c + bcd
    assign out_sop = (~a & ~b & c) | (b & c & d);
    
    // POS = (b+c)(c+d)(a'+c)
    assign out_pos = (b | c) & (c | d) & (~a | c);
endmodule
