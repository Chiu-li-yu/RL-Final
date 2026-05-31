module TopModule (
    input [3:0] x,
    output f
);
    // Let's re-map strictly based on:
    // Rows: x[3] x[2]
    // Cols: x[1] x[0]
    // Map:
    //      x1 x0
    //      00 01 11 10
    // x3x2
    // 00 | d | 0 | d | d |
    // 01 | 0 | d | 1 | 0 |
    // 11 | 1 | 1 | d | d |
    // 10 | 1 | 1 | 0 | d |
    
    // Choose d=0 for strict adherence if d=1 fails.
    // Minterms (f=1):
    // 0111 (Wait: Row 01, Col 11 is '1') -> 0111
    // 1100 (Row 11, Col 00 is '1') -> 1100
    // 1101 (Row 11, Col 01 is '1') -> 1101
    // 1000 (Row 10, Col 00 is '1') -> 1000
    // 1001 (Row 10, Col 01 is '1') -> 1001

    logic f_val;
    always @(*) begin
        case(x)
            4'b0111: f_val = 1'b1;
            4'b1100: f_val = 1'b1;
            4'b1101: f_val = 1'b1;
            4'b1000: f_val = 1'b1;
            4'b1001: f_val = 1'b1;
            default: f_val = 1'b0;
        endcase
    end

    assign f = f_val;

endmodule