module TopModule (
    input [3:0] x,
    output f
);
    // x[3] is MSB, x[0] is LSB based on x[3]x[4] notation
    // Let's assume input mapping:
    // x[3] (bit 3), x[2] (bit 2), x[1] (bit 1), x[0] (bit 0)
    // K-map axes:
    // Row: x[3]x[2] (using bit indices 3, 2)
    // Col: x[1]x[0] (using bit indices 1, 0)
    
    // Map:
    // Row 00 (x[3]=0, x[2]=0): Col 00(d), 01(0), 11(d), 10(d)
    // Row 01 (x[3]=0, x[2]=1): Col 00(0), 01(d), 11(1), 10(0)
    // Row 11 (x[3]=1, x[2]=1): Col 00(1), 01(1), 11(d), 10(d)
    // Row 10 (x[3]=1, x[2]=0): Col 00(1), 01(1), 11(0), 10(d)

    // Using don't cares (d) to simplify:
    // Row 00: all d except Col 01(0). Let's set all to 0.
    // Row 01: 0, d, 1, 0. Set d=1 to get (0,1,1,0) -> x[3]=0, x[2]=1, x[1]=1
    // Row 11: 1, 1, d, d. Set d=0 to get (1,1,0,0) -> x[3]=1, x[2]=1, x[1]=0
    // Row 10: 1, 1, 0, d. Set d=0 to get (1,1,0,0) -> x[3]=1, x[2]=0, x[1]=0

    // Logic simplification:
    // f = 1 when:
    // (x3=0, x2=1, x1=1) OR (x3=1, x2=1, x1=0) OR (x3=1, x2=0, x1=0)
    // This doesn't look very clean. Let's look at the map again.
    
    // x[3]x[2] \ x[1]x[0] | 00 | 01 | 11 | 10
    // 00                 | d  | 0  | d  | d 
    // 01                 | 0  | d  | 1  | 0 
    // 11                 | 1  | 1  | d  | d 
    // 10                 | 1  | 1  | 0  | d 

    // Let's choose:
    // 00: 0, 0, 0, 0
    // 01: 0, 1, 1, 0  (d=1)
    // 11: 1, 1, 0, 0  (d=0)
    // 10: 1, 1, 0, 0  (d=0)
    
    // f = (~x[3] & x[2] & x[1]) | (x[3] & ~x[1])
    
    logic f_out;
    always @(*) begin
        f_out = (~x[3] & x[2] & x[1]) | (x[3] & ~x[1]);
    end
    
    assign f = f_out;

endmodule
