module TopModule (
    input logic [3:0] x,
    output logic f
);
    // The prompt says: 
    //   x[1]x[2] are columns
    //   x[3]x[4] are rows
    // This is unusual. Let's try mapping the bits to the table indices carefully.
    // Let RowIndex = {x[3], x[4]} (Wait, is x 4-bit? yes, x[3:0])
    // So maybe x[3] and x[2] are the rows, and x[1] and x[0] are the columns.
    // The columns are labeled 00, 01, 11, 10 (Gray code).
    // Let's re-map the column index from binary x[1]x[0] to gray index:
    // Binary: 00 -> 0, 01 -> 1, 10 -> 2, 11 -> 3
    // Gray: 00 -> 0, 01 -> 1, 11 -> 2, 10 -> 3
    
    // Row bits: x[3], x[2]
    // Col bits: x[1], x[0]
    
    // Let's write the map strictly:
    // Table[Row][Col]
    // Col Index (x[1]x[0]): 00 (0), 01 (1), 11 (2), 10 (3)
    // Row Index (x[3]x[2]): 00 (0), 01 (1), 11 (2), 10 (3)

    // Grid:
    //      C: 00  01  11  10
    // R:00    d   0   d   d
    // R:01    0   d   1   0
    // R:11    1   1   d   d
    // R:10    1   1   0   d
    
    // Let's decode:
    // R00C00(0000)=d, R00C01(0001)=0, R00C11(0011)=d, R00C10(0010)=d
    // R01C00(0100)=0, R01C01(0101)=d, R01C11(0111)=1, R01C10(0110)=0
    // R11C00(1100)=1, R11C01(1101)=1, R11C11(1111)=d, R11C10(1110)=d
    // R10C00(1000)=1, R10C01(1001)=1, R10C11(1011)=0, R10C10(1010)=d

    always @(*) begin
        // Mapping based on R(x[3]x[2]) and C(x[1]x[0])
        case (x)
            4'b0000: f = 1'b0; // d=0
            4'b0001: f = 1'b0;
            4'b0011: f = 1'b0; // d=0
            4'b0010: f = 1'b0; // d=0
            4'b0100: f = 1'b0;
            4'b0101: f = 1'b1; // d=1
            4'b0111: f = 1'b1;
            4'b0110: f = 1'b0;
            4'b1100: f = 1'b1;
            4'b1101: f = 1'b1;
            4'b1111: f = 1'b1; // d=1
            4'b1110: f = 1'b1; // d=1
            4'b1000: f = 1'b1;
            4'b1001: f = 1'b1;
            4'b1011: f = 1'b0;
            4'b1010: f = 1'b0; // d=0
            default: f = 1'b0;
        endcase
    end
endmodule
