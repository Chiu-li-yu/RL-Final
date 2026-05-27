module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    logic [8:0] temp_sum;

    always @(*) begin
        temp_sum = {a[7], a} + {b[7], b};
    end

    assign s = temp_sum[7:0];

    // Overflow occurs if:
    // 1. Adding two positive numbers results in a negative number (a[7]=0, b[7]=0, s[7]=1)
    // 2. Adding two negative numbers results in a positive number (a[7]=1, b[7]=1, s[7]=0)
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);

endmodule
