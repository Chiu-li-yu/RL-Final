module TopModule (
    input logic [3:0] x,
    input logic [3:0] y,
    output logic [4:0] sum
);
    logic c1, c2, c3, c4;

    // Full Adder logic
    always @(*) begin
        // Bit 0
        sum[0] = x[0] ^ y[0];
        c1 = x[0] & y[0];

        // Bit 1
        sum[1] = x[1] ^ y[1] ^ c1;
        c2 = (x[1] & y[1]) | (c1 & (x[1] ^ y[1]));

        // Bit 2
        sum[2] = x[2] ^ y[2] ^ c2;
        c3 = (x[2] & y[2]) | (c2 & (x[2] ^ y[2]));

        // Bit 3
        sum[3] = x[3] ^ y[3] ^ c3;
        c4 = (x[3] & y[3]) | (c3 & (x[3] ^ y[3]));

        // Final carry
        sum[4] = c4;
    end
endmodule