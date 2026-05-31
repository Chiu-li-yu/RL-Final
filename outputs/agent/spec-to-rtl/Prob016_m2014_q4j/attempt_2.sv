module TopModule (
    input [3:0] x,
    input [3:0] y,
    output logic [4:0] sum
);
    logic [3:0] s;
    logic [4:0] c;

    always @(*) begin
        c[0] = 1'b0;
        s[0] = x[0] ^ y[0] ^ c[0];
        c[1] = (x[0] & y[0]) | (c[0] & (x[0] ^ y[0]));

        s[1] = x[1] ^ y[1] ^ c[1];
        c[2] = (x[1] & y[1]) | (c[1] & (x[1] ^ y[1]));

        s[2] = x[2] ^ y[2] ^ c[2];
        c[3] = (x[2] & y[2]) | (c[2] & (x[2] ^ y[2]));

        s[3] = x[3] ^ y[3] ^ c[3];
        c[4] = (x[3] & y[3]) | (c[3] & (x[3] ^ y[3]));

        sum = {c[4], s[3], s[2], s[1], s[0]};
    end
endmodule
