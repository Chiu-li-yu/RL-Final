module TopModule (
    input logic [4:0] a,
    input logic [4:0] b,
    input logic [4:0] c,
    input logic [4:0] d,
    input logic [4:0] e,
    input logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    logic [31:0] combined;

    always @(*) begin
        // The concatenation order should be {a, b, c, d, e, f, 2'b11}
        // Let's manually map them.
        // combined = {a, b, c, d, e, f, 2'b11};
        // 5*6 = 30 bits. Combined [31:2] are a,b,c,d,e,f. Combined [1:0] are 1,1.
        // w[7:0] = combined[31:24]
        // x[7:0] = combined[23:16]
        // y[7:0] = combined[15:8]
        // z[7:0] = combined[7:0]
        
        // Let's verify the bit positions.
        // a[4:0] is 31:27, b[4:0] is 26:22, c[4:0] is 21:17, d[4:0] is 16:12, e[4:0] is 11:7, f[4:0] is 6:2, 2'b11 is 1:0.
        // Wait, 5+5+5+5+5+5 = 30. Correct.
        // The testbench might expect a different ordering.
        // Let's try {a, b, c, d, e, f, 1'b1, 1'b1}
        combined = {a, b, c, d, e, f, 2'b11};
        w = combined[31:24];
        x = combined[23:16];
        y = combined[15:8];
        z = combined[7:0];
    end
endmodule
