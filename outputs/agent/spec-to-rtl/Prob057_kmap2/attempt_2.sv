module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map (cd/ab):
    //      ab
    // cd | 00 01 11 10
    // 00 | 1  1  0  1
    // 01 | 1  0  0  1
    // 11 | 0  1  1  1
    // 10 | 1  1  0  0
    
    // We map the bits to logic levels (cd, ab)
    // 0000: 1, 0001: 1, 0011: 0, 0010: 1
    // 0100: 1, 0101: 0, 0111: 0, 0110: 1
    // 1100: 0, 1101: 1, 1111: 1, 1110: 1
    // 1000: 1, 1001: 1, 1011: 0, 1010: 0

    // Using Sum-of-Products from 1s:
    // (a'b'c'd') + (a'b'c'd) + (a'b'cd') + (a'bc'd') + (ab'c'd') + (ab'c'd) + (abc'd) + (abcd) + (abc d') + (a'bc d)
    // Let's re-verify the map values carefully.
    // Row 00 (c=0, d=0): (00,00)=1, (01,00)=1, (11,00)=0, (10,00)=1  => abcd = 0000, 0100, 1100, 1000
    // Row 01 (c=0, d=1): (00,01)=1, (01,01)=0, (11,01)=0, (10,01)=1  => abcd = 0001, 0101, 1101, 1001
    // Row 11 (c=1, d=1): (00,11)=0, (01,11)=1, (11,11)=1, (10,11)=1  => abcd = 0011, 0111, 1111, 1011
    // Row 10 (c=1, d=0): (00,10)=1, (01,10)=1, (11,10)=0, (10,10)=0  => abcd = 0010, 0110, 1110, 1010

    logic out_val;
    always @(*) begin
        case ({c, d, a, b})
            4'b0000: out_val = 1;
            4'b0001: out_val = 1;
            4'b0010: out_val = 0;
            4'b0011: out_val = 1;
            4'b0100: out_val = 1;
            4'b0101: out_val = 0;
            4'b0110: out_val = 0;
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
