module TopModule (
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] s,
    output logic overflow
);

    logic signed [7:0] signed_a;
    logic signed [7:0] signed_b;
    logic signed [8:0] sum;

    always @(*) begin
        signed_a = a;
        signed_b = b;
        sum = signed_a + signed_b;
        s = sum[7:0];
        
        // Overflow occurs if the sign bit of the result is different 
        // from the sign bits of the operands when operands have the same sign.
        overflow = ((signed_a[7] == signed_b[7]) && (sum[7] != signed_a[7]));
    end

endmodule
