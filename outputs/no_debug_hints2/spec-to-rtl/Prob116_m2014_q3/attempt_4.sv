module TopModule(
    input [3:0] x,
    output f
);
    // The previous assumptions about which bit is which might be wrong.
    // Specification:
    // x (4 bits)
    // Map:
    // row x[3]x[4] -> Maybe x[3] is x[3], x[4] is x[2]?
    // col x[1]x[2] -> Maybe x[1] is x[1], x[2] is x[0]?
    // Let's try: row = {x[3], x[2]}, col = {x[1], x[0]} (already tried)
    // Maybe: row = {x[0], x[1]}, col = {x[2], x[3]} ?
    // Or: row = x[3] (MSB), x[2] (next), x[1], x[0] (LSB)
    
    // Let's reconsider the K-map labels:
    // Row label: "x[3]x[4]"
    // Col label: "x[1]x[2]"
    // This is VERY suspicious. Is there an x[4] in a 4-bit input?
    // Maybe the input is x[0], x[1], x[2], x[3], x[4]?
    // But the spec says "input x (4 bits)".
    
    // Could the labels be typos for:
    // Row: x[3]x[2]
    // Col: x[1]x[0]
    // Yes, this is most likely.
    
    // What if the map was not read as binary 00, 01, 11, 10?
    // What if the order is 00, 01, 10, 11? (Gray code is 00, 01, 11, 10)
    // The provided map uses Gray code: 00, 01, 11, 10.
    
    // Let's use truth table from the map and just build a CASE statement.
    // This is the safest way to avoid mapping errors.
    
    // Rows: x3x2, Cols: x1x0
    //     00  01  11  10
    // 00 | d | 0 | d | d |
    // 01 | 0 | d | 1 | 0 |
    // 11 | 1 | 1 | d | d |
    // 10 | 1 | 1 | 0 | d |
    
    always @(*) begin
        case (x)
            4'b0000: f = 0; // d
            4'b0001: f = 0;
            4'b0011: f = 0; // d
            4'b0010: f = 0; // d
            4'b0100: f = 0;
            4'b0101: f = 1; // d
            4'b0111: f = 1;
            4'b0110: f = 0;
            4'b1100: f = 1;
            4'b1101: f = 1;
            4'b1111: f = 0; // d
            4'b1110: f = 0; // d
            4'b1000: f = 1;
            4'b1001: f = 1;
            4'b1011: f = 0;
            4'b1010: f = 0; // d
            default: f = 0;
        endcase
    end
endmodule
