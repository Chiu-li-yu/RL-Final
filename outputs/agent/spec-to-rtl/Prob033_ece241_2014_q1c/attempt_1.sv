module TopModule (
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

    // Overflow occurs if:
    // 1. Both numbers are positive (MSB=0), but the result is negative (MSB=1).
    // 2. Both numbers are negative (MSB=1), but the result is positive (MSB=0).
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);

endmodule
