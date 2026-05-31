module TopModule (
    input logic [3:0] x,
    output logic f
);
    // Based on standard K-map row/col ordering:
    // Rows: x[3] x[2]
    // Cols: x[1] x[0]
    // Value = Table[Row][Col]
    // Values:
    // 0000: d, 0001: 0, 0011: d, 0010: d
    // 0100: 0, 0101: d, 0111: 1, 0110: 0
    // 1100: 1, 1101: 1, 1111: d, 1110: d
    // 1000: 1, 1001: 1, 1011: 0, 1010: d

    // Let's try filling d's to simplify the logic:
    // d(0000)=0, d(0011)=0, d(0010)=0
    // d(0101)=1
    // d(1111)=1, d(1110)=1
    // d(1010)=1
    
    // Map:
    // 0000:0, 0001:0, 0011:0, 0010:0
    // 0100:0, 0101:1, 0111:1, 0110:0
    // 1100:1, 1101:1, 1111:1, 1110:1
    // 1000:1, 1001:1, 1011:0, 1010:1
    
    always @(*) begin
        case (x)
            4'b0000: f = 1'b0;
            4'b0001: f = 1'b0;
            4'b0010: f = 1'b0;
            4'b0011: f = 1'b0;
            4'b0100: f = 1'b0;
            4'b0101: f = 1'b1;
            4'b0110: f = 1'b0;
            4'b0111: f = 1'b1;
            4'b1000: f = 1'b1;
            4'b1001: f = 1'b1;
            4'b1010: f = 1'b1;
            4'b1011: f = 1'b0;
            4'b1100: f = 1'b1;
            4'b1101: f = 1'b1;
            4'b1110: f = 1'b1;
            4'b1111: f = 1'b1;
        endcase
    end
endmodule
