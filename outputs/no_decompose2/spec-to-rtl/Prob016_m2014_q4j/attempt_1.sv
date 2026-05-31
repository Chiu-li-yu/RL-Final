module TopModule (
    input logic [3:0] x,
    input logic [3:0] y,
    output logic [4:0] sum
);

    logic [4:0] c;

    assign c[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : fa
            assign sum[i] = x[i] ^ y[i] ^ c[i];
            assign c[i+1] = (x[i] & y[i]) | (c[i] & (x[i] ^ y[i]));
        end
    endgenerate

    assign sum[4] = c[4];

endmodule
