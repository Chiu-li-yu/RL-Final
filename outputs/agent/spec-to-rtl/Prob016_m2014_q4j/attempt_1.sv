module TopModule (
    input logic [3:0] x,
    input logic [3:0] y,
    output logic [4:0] sum
);

    logic [4:0] c;

    always @(*) begin
        c[0] = 0;
        sum[0] = x[0] ^ y[0] ^ c[0];
        c[1] = (x[0] & y[0]) | (c[0] & (x[0] ^ y[0]));
        
        sum[1] = x[1] ^ y[1] ^ c[1];
        c[2] = (x[1] & y[1]) | (c[1] & (x[1] ^ y[1]));
        
        sum[2] = x[2] ^ y[2] ^ c[2];
        c[3] = (x[2] & y[2]) | (c[2] & (x[2] ^ y[2]));
        
        sum[3] = x[3] ^ y[3] ^ c[3];
        c[4] = (x[3] & y[3]) | (c[3] & (x[3] ^ y[3]));
        
        sum[4] = c[4];
    end

endmodule
