module TopModule (
    input [3:0] x,
    output logic f
);
    // K-map:
    //          x0 x1
    // x2 x3    00 01 11 10
    // 00       1  0  0  1
    // 01       0  0  0  0
    // 11       1  1  1  0
    // 10       1  1  0  1

    // x[2] is x2, x[3] is x3, x[0] is x0, x[1] is x1
    // Row 00: x2=0, x3=0. f=1 when (x0,x1) in {00, 10} => x=0000, 0001
    // Row 01: x2=0, x3=1. f=0.
    // Row 11: x2=1, x3=1. f=1 when (x0,x1) in {00, 01, 11} => x=1100, 1101, 1111
    // Row 10: x2=1, x3=0. f=1 when (x0,x1) in {00, 01, 10} => x=1000, 1001, 1010

    // Wait, the column indices in the K-map:
    // x[0]x[1]
    // 00 01 11 10
    // If x[0] is MSB of column index, x[1] is LSB:
    // 00 -> 00, 01 -> 01, 11 -> 11, 10 -> 10
    // Let's re-map based on (x2, x3, x0, x1) being the order in input [3:0]?
    // Usually x = {x3, x2, x1, x0} but the problem says input x (4 bits), so x[3], x[2], x[1], x[0].
    // Let's check the labels:
    // x2x3 are row bits. x0x1 are col bits.
    // My previous assumption was x[2] corresponds to K-map x[2], x[3] to K-map x[3].
    // Let's try every mapping.

    // Try mapping:
    // K-map x[2] = x[3], x[3] = x[2], x[0] = x[1], x[1] = x[0]
    // Or just look at the table again:
    // Row index: x[2]x[3]
    // Col index: x[0]x[1]
    // Inputs: x[3] x[2] x[1] x[0]
    // Let's interpret the K-map as a function of the 4 bits:
    // f(x[2], x[3], x[0], x[1])

    logic x2, x3, x0, x1;
    assign x3 = x[3];
    assign x2 = x[2];
    assign x1 = x[1];
    assign x0 = x[0];

    // The K-map table coordinates are R=x2x3, C=x0x1
    // Let's map coordinates to bits:
    // (x2, x3, x0, x1)
    always @(*) begin
        case ({x2, x3, x0, x1})
            4'b0000: f = 1'b1;
            4'b0010: f = 1'b1; // Row 00, Col 10 (x2=0, x3=0, x0=1, x1=0)
            4'b1100: f = 1'b1; // Row 11, Col 00 (x2=1, x3=1, x0=0, x1=0)
            4'b1101: f = 1'b1; // Row 11, Col 01
            4'b1111: f = 1'b1; // Row 11, Col 11
            4'b1000: f = 1'b1; // Row 10, Col 00
            4'b1001: f = 1'b1; // Row 10, Col 01
            4'b1010: f = 1'b1; // Row 10, Col 10
            default: f = 1'b0;
        endcase
    end
endmodule
