module TopModule (
    input [3:0] x,
    output logic f
);
    // Let's re-map based on standard 4-bit input x[3:0]
    // The problem states K-map uses x[3]x[4] and x[1]x[2].
    // This is often a way to label variables regardless of the actual bit index.
    // Let's assume x[3] is the first bit of the input, x[2] the second, x[1] the third, x[0] the fourth.
    // Therefore x[3]x[4] is input x[3]x[2] and x[1]x[2] is input x[1]x[0].
    
    // Truth table based on provided K-map:
    // Bits: x[3]x[2] x[1]x[0]
    // Value: f
    
    always @(*) begin
        case (x)
            4'b0101: f = 1;
            4'b0111: f = 1;
            4'b1100: f = 1;
            4'b1101: f = 1;
            4'b1000: f = 1;
            4'b1001: f = 1;
            // The others:
            // 0000, 0001, 0011, 0010, 0100, 0110, 1111, 1110, 1011, 1010
            // based on map (d is don't care, I'll set to 0 for them)
            default: f = 0;
        endcase
    end
endmodule
