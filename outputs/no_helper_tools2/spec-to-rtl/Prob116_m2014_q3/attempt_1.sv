module TopModule (
    input logic [3:0] x,
    output logic f
);
    // K-map decoding:
    // x = [x[3], x[2], x[1], x[0]] based on the provided table:
    // Row (x[3]x[2]): 00, 01, 11, 10
    // Col (x[1]x[0]): 00, 01, 11, 10
    // Wait, the K-map says x[1]x[2] and x[3]x[4].
    // Assuming x[3] is MSB, x[0] is LSB.
    // The prompt says x[1]x[2] as columns and x[3]x[4] as rows.
    // Let's map x[3]x[2] to Row and x[1]x[0] to Column.
    
    // x[3] corresponds to row bit 1, x[2] corresponds to row bit 0.
    // x[1] corresponds to col bit 1, x[0] corresponds to col bit 0.

    always @(*) begin
        case (x)
            4'b0000: f = 1'b0; // d -> 0
            4'b0001: f = 1'b0;
            4'b0011: f = 1'b0; // d -> 0
            4'b0010: f = 1'b0; // d -> 0
            4'b0100: f = 1'b0;
            4'b0101: f = 1'b1; // d -> 1
            4'b0111: f = 1'b1;
            4'b0110: f = 1'b0;
            4'b1100: f = 1'b1;
            4'b1101: f = 1'b1;
            4'b1111: f = 1'b1; // d -> 1
            4'b1110: f = 1'b1; // d -> 1
            4'b1000: f = 1'b1;
            4'b1001: f = 1'b1;
            4'b1011: f = 1'b0; // d -> 0
            4'b1010: f = 1'b0; // d -> 0
            default: f = 1'b0;
        endcase
    end
endmodule
