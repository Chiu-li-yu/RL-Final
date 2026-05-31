module TopModule (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    logic [8:0] sum;

    always @(*) begin
        sum = {a[7], a} + {b[7], b};
        s = sum[7:0];
        // Overflow occurs if the result's MSB (sign bit) is different 
        // from the sign bits of both operands.
        // Specifically, for addition: (a > 0 && b > 0 && s < 0) || (a < 0 && b < 0 && s > 0)
        overflow = (a[7] == b[7]) && (a[7] != s[7]);
    end
endmodule
