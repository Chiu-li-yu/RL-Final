module TopModule (
    input [3:0] x,
    output f
);
    // Let's re-interpret the K-map carefully.
    // x = {x[3], x[2], x[1], x[0]}
    // Row index = {x[2], x[3]}
    // Col index = {x[0], x[1]}
    
    // K-map matrix:
    // (r, c) | 00 | 01 | 11 | 10
    // 00     | 1  | 0  | 0  | 1
    // 01     | 0  | 0  | 0  | 0
    // 11     | 1  | 1  | 1  | 0
    // 10     | 1  | 1  | 0  | 1

    // Map K-map indices (r=x2,x3, c=x0,x1) to (x3, x2, x1, x0)
    // Row 00 (x2=0, x3=0): 
    //   c00 (x0=0, x1=0) -> x=0000 -> f=1
    //   c01 (x0=0, x1=1) -> x=0010 -> f=0
    //   c11 (x0=1, x1=1) -> x=0011 -> f=0
    //   c10 (x0=1, x1=0) -> x=0001 -> f=1
    
    // Row 01 (x2=0, x3=1):
    //   c00 (x0=0, x1=0) -> x=1000 -> f=0
    //   c01 (x0=0, x1=1) -> x=1010 -> f=0
    //   c11 (x0=1, x1=1) -> x=1011 -> f=0
    //   c10 (x0=1, x1=0) -> x=1001 -> f=0
    
    // Row 11 (x2=1, x3=1):
    //   c00 (x0=0, x1=0) -> x=1100 -> f=1
    //   c01 (x0=0, x1=1) -> x=1110 -> f=1
    //   c11 (x0=1, x1=1) -> x=1111 -> f=1
    //   c10 (x0=1, x1=0) -> x=1101 -> f=0
    
    // Row 10 (x2=1, x3=0):
    //   c00 (x0=0, x1=0) -> x=0100 -> f=1
    //   c01 (x0=0, x1=1) -> x=0110 -> f=1
    //   c11 (x0=1, x1=1) -> x=0111 -> f=0
    //   c10 (x0=1, x1=0) -> x=0101 -> f=1

    logic f_val;
    always @(*) begin
        case (x)
            4'b0000: f_val = 1;
            4'b0001: f_val = 1;
            4'b1100: f_val = 1;
            4'b1110: f_val = 1;
            4'b1111: f_val = 1;
            4'b0100: f_val = 1;
            4'b0110: f_val = 1;
            4'b0101: f_val = 1;
            default: f_val = 0;
        endcase
    end
    assign f = f_val;
endmodule
