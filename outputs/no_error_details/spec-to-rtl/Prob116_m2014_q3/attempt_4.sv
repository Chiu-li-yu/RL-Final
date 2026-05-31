module TopModule (
    input [3:0] x,
    output f
);
    // Maybe the K-map inputs order is different?
    // "x[3]x[4]   00  01  11  10"
    // "x[1]x[2]   00  01  11  10"
    // This looks like row header is x[3], x[4] and col header is x[1], x[2].
    // But input x is 4 bits: x[3:0].
    // If x[3], x[2] are rows, and x[1], x[0] are cols:
    
    // Row 00 (x3=0, x2=0): d, 0, d, d (cols: x1x0=00,01,11,10)
    // Row 01 (x3=0, x2=1): 0, d, 1, 0
    // Row 11 (x3=1, x2=1): 1, 1, d, d
    // Row 10 (x3=1, x2=0): 1, 1, 0, d

    // Let's re-verify the table:
    // f(0,0,0,0)=0, f(0,0,0,1)=0, f(0,0,1,1)=0, f(0,0,1,0)=0
    // f(0,1,0,0)=0, f(0,1,0,1)=0, f(0,1,1,1)=1, f(0,1,1,0)=0
    // f(1,1,0,0)=1, f(1,1,0,1)=1, f(1,1,1,1)=0, f(1,1,1,0)=0
    // f(1,0,0,0)=1, f(1,0,0,1)=1, f(1,0,1,1)=0, f(1,0,1,0)=0
    
    // Logic:
    // f = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & x[2] & ~x[1] & ~x[0]) | (x[3] & ~x[2] & ~x[1] & ~x[0]) | (x[3] & x[2] & ~x[1] & x[0]) | (x[3] & ~x[2] & ~x[1] & x[0])
    // Simplified:
    // f = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[1] & ~x[0]) | (x[3] & x[2] & ~x[1])
    
    logic f_val;
    always @(*) begin
        f_val = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[1] & ~x[0]) | (x[3] & x[2] & ~x[1] & x[0]);
    end

    assign f = f_val;
endmodule