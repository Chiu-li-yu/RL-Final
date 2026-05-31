module TopModule(
    input [3:0] x,
    output f
);

// Map K-map to standard indices:
// Row: x[3:2] -> actually the spec says:
//   x[3]x[4] as rows and x[1]x[2] as columns
// Wait, the input is x (4 bits). Usually x[3] is MSB.
// The table is:
// row: x[3]x[4]
// col: x[1]x[2]
// This implies the input vector x is {x[3], x[4], x[1], x[2]}?
// Or does it mean bit 3 is index 0 and bit 4 is index 1?
// Looking at the K-map labels:
// x[3]x[4] are rows, x[1]x[2] are columns.
// This is non-standard bit numbering.
// Let's interpret:
// row = {x[3], x[4]}
// col = {x[1], x[2]}

logic [1:0] row;
logic [1:0] col;

always @(*) begin
    row = {x[3], x[2]}; // wait, the spec says x[3]x[4]
    // Let's re-read: "x[3]x[4]" "x[1]x[2]"
    // If x is 4 bits: x[3], x[2], x[1], x[0]
    // Maybe the spec means:
    // row = {x[3], x[2]}
    // col = {x[1], x[0]}
    // Let's assume standard indexing: x[3] is MSB (bit 3), x[0] is LSB (bit 0).
    // The spec labels are x[3]x[4] and x[1]x[2]. This is very weird for 4 bits.
    // I will assume the indices in the table *are* the bit indices.
    // So row is {x[3], x[2]} and col is {x[1], x[0]}.
end

// Let's use a simple case statement to map the truth table:
// Mapping:
// {x[3], x[2], x[1], x[0]} -> f
// 0000: d -> 0
// 0001: 0 -> 0
// 0010: d -> 0
// 0011: d -> 0
// 0100: 0 -> 0
// 0101: d -> 1 (let's pick 1 for convenience)
// 0110: 1 -> 1
// 0111: 0 -> 0
// 1100: 1 -> 1
// 1101: 1 -> 1
// 1110: d -> 0
// 1111: d -> 0
// 1000: 1 -> 1
// 1001: 1 -> 1
// 1010: 0 -> 0
// 1011: d -> 0

logic result;
always @(*) begin
    case(x)
        4'b0000: result = 1'b0; // d
        4'b0001: result = 1'b0;
        4'b0010: result = 1'b0; // d
        4'b0011: result = 1'b0; // d
        4'b0100: result = 1'b0;
        4'b0101: result = 1'b1; // d
        4'b0110: result = 1'b1;
        4'b0111: result = 1'b0;
        4'b1100: result = 1'b1;
        4'b1101: result = 1'b1;
        4'b1110: result = 1'b0; // d
        4'b1111: result = 1'b0; // d
        4'b1000: result = 1'b1;
        4'b1001: result = 1'b1;
        4'b1010: result = 1'b0;
        4'b1011: result = 1'b0; // d
        default: result = 1'b0;
    endcase
end

assign f = result;

endmodule
