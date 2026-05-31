module TopModule (
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] s,
    output logic       overflow
);

    logic [8:0] sum;

    always @(*) begin
        sum = {a[7], a} + {b[7], b};
        s = sum[7:0];
        
        // Overflow occurs if the signs of inputs are the same,
        // but the sign of the result is different.
        // Specifically:
        // if a[7] == b[7] and s[7] != a[7]
        overflow = (a[7] == b[7]) && (s[7] != a[7]);
    end

endmodule
