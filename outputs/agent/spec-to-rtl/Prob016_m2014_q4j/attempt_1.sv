module TopModule (
    input [3:0] x,
    input [3:0] y,
    output logic [4:0] sum
);

    logic [4:0] c;

    always @(*) begin
        // Full Adder 0
        c[0] = 1'b0;
        sum[0] = x[0] ^ y[0] ^ c[0];
        c[1] = (x[0] & y[0]) | (c[0] & (x[0] ^ y[0]));

        // Full Adder 1
        sum[1] = x[1] ^ y[1] ^ c[1];
        c[2] = (x[1] & y[1]) | (c[1] & (x[1] ^ y[1]));

        // Full Adder 2
        sum[2] = x[2] ^ y[2] ^ c[2];
        c[3] = (x[2] & y[2]) | (c[2] & (x[2] ^ y[2]));

        // Full Adder 3
        sum[3] = x[3] ^ y[3] ^ c[3];
        c[4] = (x[3] & y[3]) | (c[3] & (x[3] ^ y[3]));

        // Overflow bit
        sum[4] = c[4];
    end

endmodule
