module TopModule (
    input logic [3:0] x,
    output logic f
);
    // Re-evaluating indices based on table labels x[2]x[3] and x[0]x[1]:
    // Row 00 (x2=0, x3=0): col 00 (x0=0, x1=0) -> 1, col 01 (x0=0, x1=1) -> 0, col 11 (x0=1, x1=1) -> 0, col 10 (x0=1, x1=0) -> 1
    // Row 01 (x2=0, x3=1): col 00 (x0=0, x1=0) -> 0, col 01 (x0=0, x1=1) -> 0, col 11 (x0=1, x1=1) -> 0, col 10 (x0=1, x1=0) -> 0
    // Row 11 (x2=1, x3=1): col 00 (x0=0, x1=0) -> 1, col 01 (x0=0, x1=1) -> 1, col 11 (x0=1, x1=1) -> 1, col 10 (x0=1, x1=0) -> 0
    // Row 10 (x2=1, x3=0): col 00 (x0=0, x1=0) -> 1, col 01 (x0=0, x1=1) -> 1, col 11 (x0=1, x1=1) -> 0, col 10 (x0=1, x1=0) -> 1

    // Let's map x[3], x[2], x[1], x[0] as the bits... actually, let's just use the table
    // K-map: row index = x[2:3], col index = x[0:1]
    
    always @(*) begin
        case (x)
            4'b0000: f = 1'b1;
            4'b0001: f = 1'b0;
            4'b0011: f = 1'b0;
            4'b0010: f = 1'b1;
            4'b0100: f = 1'b0;
            4'b0101: f = 1'b0;
            4'b0111: f = 1'b0;
            4'b0110: f = 1'b0;
            4'b1100: f = 1'b1;
            4'b1101: f = 1'b1;
            4'b1111: f = 1'b1;
            4'b1110: f = 1'b0;
            4'b1000: f = 1'b1;
            4'b1001: f = 1'b1;
            4'b1011: f = 1'b0;
            4'b1010: f = 1'b1;
            default: f = 1'b0;
        endcase
    end
endmodule
