module TopModule (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    logic [4:0] carry;

    assign carry[0] = 1'b0;

    always @(*) begin
        sum[0] = x[0] ^ y[0] ^ carry[0];
        carry[1] = (x[0] & y[0]) | (x[0] & carry[0]) | (y[0] & carry[0]);

        sum[1] = x[1] ^ y[1] ^ carry[1];
        carry[2] = (x[1] & y[1]) | (x[1] & carry[1]) | (y[1] & carry[1]);

        sum[2] = x[2] ^ y[2] ^ carry[2];
        carry[3] = (x[2] & y[2]) | (x[2] & carry[2]) | (y[2] & carry[2]);

        sum[3] = x[3] ^ y[3] ^ carry[3];
        carry[4] = (x[3] & y[3]) | (x[3] & carry[3]) | (y[3] & carry[3]);

        sum[4] = carry[4];
    end
endmodule
