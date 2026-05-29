
module TopModule (
    input [3:0] x,
    output logic f
);

    always @(*) begin
        case (x)
            // x = {x[3], x[2], x[1], x[0]}
            // Row (x[2], x[3]), Col (x[0], x[1])
            
            // Row 00: x[2]=0, x[3]=0
            4'b0000: f = 1'b0; // Col 00: d
            4'b0010: f = 1'b0; // Col 01: 0
            4'b0011: f = 1'b0; // Col 11: d
            4'b0001: f = 1'b0; // Col 10: d
            
            // Row 01: x[2]=0, x[3]=1
            4'b1000: f = 1'b0; // Col 00: 0
            4'b1010: f = 1'b0; // Col 01: d
            4'b1011: f = 1'b1; // Col 11: 1
            4'b1001: f = 1'b0; // Col 10: 0
            
            // Row 11: x[2]=1, x[3]=1
            4'b1100: f = 1'b1; // Col 00: 1
            4'b1110: f = 1'b1; // Col 01: 1
            4'b1111: f = 1'b0; // Col 11: d
            4'b1101: f = 1'b0; // Col 10: d
            
            // Row 10: x[2]=1, x[3]=0
            4'b0100: f = 1'b1; // Col 00: 1
            4'b0110: f = 1'b1; // Col 01: 1
            4'b0111: f = 1'b0; // Col 11: 0
            4'b0101: f = 1'b0; // Col 10: d
            
            default: f = 1'b0;
        endcase
    end
endmodule
