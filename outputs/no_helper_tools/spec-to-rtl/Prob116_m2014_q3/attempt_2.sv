module TopModule (
    input logic [3:0] x,
    output logic f
);
    // x[3], x[2], x[1], x[0]
    // K-map:
    // Rows (x[3]x[2]): 00, 01, 11, 10
    // Cols (x[1]x[0]): 00, 01, 11, 10
    
    // Grid:
    //      00 01 11 10
    // 00 | d  0  d  d
    // 01 | 0  d  1  0
    // 11 | 1  1  d  d
    // 10 | 1  1  0  d

    // Let's set 'd' values to minimize logic:
    // (0,0)=0, (0,2)=0, (0,3)=0
    // (1,1)=1
    // (3,2)=0, (3,3)=0
    // (2,3)=0
    
    // Fill Table:
    //      00 01 11 10
    // 00 | 0  0  0  0
    // 01 | 0  1  1  0
    // 11 | 1  1  0  0
    // 10 | 1  1  0  0

    always @(*) begin
        case (x)
            4'b0000: f = 0;
            4'b0001: f = 0;
            4'b0010: f = 0;
            4'b0011: f = 0;
            4'b0100: f = 0;
            4'b0101: f = 1;
            4'b0110: f = 1;
            4'b0111: f = 0;
            4'b1100: f = 1;
            4'b1101: f = 1;
            4'b1110: f = 0;
            4'b1111: f = 0;
            4'b1000: f = 1;
            4'b1001: f = 1;
            4'b1010: f = 0;
            4'b1011: f = 0;
            default: f = 0;
        endcase
    end
endmodule
