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

    // Re-evaluating K-map coordinates based on input order:
    // col = a, b
    // row = c, d
    
    // (c,d) \ (a,b)
    // | | 00 | 01 | 11 | 10
    // 00| 1  | 1  | 0  | 1
    // 01| 1  | 0  | 0  | 1
    // 11| 0  | 1  | 1  | 1
    // 10| 1  | 1  | 0  | 0

    // Mapping inputs to table:
    // a b c d | out
    // 0 0 0 0 | 1
    // 0 1 0 0 | 1
    // 1 1 0 0 | 0
    // 1 0 0 0 | 1
    
    // 0 0 0 1 | 1
    // 0 1 0 1 | 0
    // 1 1 0 1 | 0
    // 1 0 0 1 | 1
    
    // 0 0 1 1 | 0
    // 0 1 1 1 | 1
    // 1 1 1 1 | 1
    // 1 0 1 1 | 1
    
    // 0 0 1 0 | 1
    // 0 1 1 0 | 1
    // 1 1 1 0 | 0
    // 1 0 1 0 | 0

    logic out_val;
    always @(*) begin
        case ({a, b, c, d})
            4'b0000: out_val = 1;
            4'b0100: out_val = 1;
            4'b1100: out_val = 0;
            4'b1000: out_val = 1;
            
            4'b0001: out_val = 1;
            4'b0101: out_val = 0;
            4'b1101: out_val = 0;
            4'b1001: out_val = 1;
            
            4'b0011: out_val = 0;
            4'b0111: out_val = 1;
            4'b1111: out_val = 1;
            4'b1011: out_val = 1;
            
            4'b0010: out_val = 1;
            4'b0110: out_val = 1;
            4'b1110: out_val = 0;
            4'b1010: out_val = 0;
            default: out_val = 0;
        endcase
    end
    
    assign out = out_val;
endmodule
