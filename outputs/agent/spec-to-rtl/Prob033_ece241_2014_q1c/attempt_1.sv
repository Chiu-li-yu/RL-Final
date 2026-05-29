module TopModule (
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] s,
    output logic overflow
);

    always @(*) begin
        s = a + b;
        // Signed overflow occurs if the sign of the result is different from the sign of the inputs,
        // provided that the inputs had the same sign.
        if ((a[7] == b[7]) && (s[7] != a[7])) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end

endmodule
