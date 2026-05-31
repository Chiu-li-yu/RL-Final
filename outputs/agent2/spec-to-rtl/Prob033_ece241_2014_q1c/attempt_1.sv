module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    logic [8:0] sum;
    assign sum = {a[7], a} + {b[7], b};
    assign s = sum[7:0];
    
    // Overflow occurs if the sign of the result is different from the signs of operands
    // (a_pos + b_pos = neg) or (a_neg + b_neg = pos)
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule
