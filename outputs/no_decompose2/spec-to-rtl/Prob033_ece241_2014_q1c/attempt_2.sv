module TopModule (
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] s,
    output logic overflow
);
    logic [8:0] sum;

    always @(*) begin
        sum = {a[7], a} + {b[7], b};
        s = sum[7:0];
        // Overflow occurs if the result's MSB (sign bit) is different 
        // from the sign bits of both operands.
        overflow = (a[7] == b[7]) && (a[7] != s[7]);
    end
endmodule
