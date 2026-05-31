module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    logic [8:0] sum;
    assign sum = {a[7], a} + {b[7], b};
    
    assign s = sum[7:0];
    
    // Overflow condition for 2's complement addition:
    // If a and b have same sign, and the result has a different sign bit.
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);

endmodule
