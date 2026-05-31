module TopModule (
    input [3:0] x,
    output f
);

    // K-map mapping:
    // x = [x[3], x[2], x[1], x[0]]  <-- Wait, the prompt says "x[1]x[2]" and "x[3]x[4]"
    // The prompt says "x (4 bits)". I will assume x[3] is MSB, x[0] is LSB.
    // Based on "x[1]x[2]" and "x[3]x[4]" notation, it seems to imply index.
    // Let's map carefully:
    // Rows (x[3]x[0]): 00, 01, 11, 10
    // Cols (x[2]x[1]): 00, 01, 11, 10
    // This is unusual. I will assume x[3] corresponds to the first bit mentioned in the pair.
    
    // Let's assume input order is:
    // x[3], x[2] are rows
    // x[1], x[0] are columns
    // K-map:
    // Row 00 (x[3]=0, x[2]=0), Col 00 (x[1]=0, x[0]=0) -> d
    // Row 00 (x[3]=0, x[2]=0), Col 01 (x[1]=0, x[0]=1) -> 0
    // ...
    // Actually, looking at "x[1]x[2]" as columns and "x[3]x[4]" as rows,
    // let's assume x[3] is the first row bit, x[2] is the second row bit,
    // x[1] is the first col bit, x[0] is the second col bit.

    logic f_logic;

    always @(*) begin
        case (x)
            4'b0000: f_logic = 1'b0; // d -> 0
            4'b0001: f_logic = 1'b0;
            4'b0011: f_logic = 1'b0; // d -> 0
            4'b0010: f_logic = 1'b0; // d -> 0
            
            4'b0100: f_logic = 1'b0;
            4'b0101: f_logic = 1'b1; // d -> 1
            4'b0111: f_logic = 1'b1;
            4'b0110: f_logic = 1'b0;
            
            4'b1100: f_logic = 1'b1;
            4'b1101: f_logic = 1'b1;
            4'b1111: f_logic = 1'b1; // d -> 1
            4'b1110: f_logic = 1'b1; // d -> 1
            
            4'b1000: f_logic = 1'b1;
            4'b1001: f_logic = 1'b1;
            4'b1011: f_logic = 1'b0; // d -> 0
            4'b1010: f_logic = 1'b0; // d -> 0
            default: f_logic = 1'b0;
        endcase
    end

    assign f = f_logic;

endmodule
