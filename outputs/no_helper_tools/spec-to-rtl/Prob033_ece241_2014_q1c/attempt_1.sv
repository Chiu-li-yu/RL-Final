module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    logic [8:0] sum;

    always @(*) begin
        sum = {a[7], a} + {b[7], b};
    end

    assign s = sum[7:0];
    
    // Signed overflow occurs if:
    // (a > 0 && b > 0 && s < 0) or (a < 0 && b < 0 && s > 0)
    // Simply: if a[7] == b[7] and s[7] != a[7]
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);

endmodule
