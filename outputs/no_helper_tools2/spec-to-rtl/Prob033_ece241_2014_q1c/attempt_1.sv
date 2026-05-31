module TopModule (
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] s,
    output logic overflow
);

    logic signed [7:0] a_signed;
    logic signed [7:0] b_signed;
    logic signed [8:0] sum_signed;

    always @(*) begin
        a_signed = a;
        b_signed = b;
        sum_signed = a_signed + b_signed;
        s = sum_signed[7:0];
        
        // Overflow occurs if:
        // 1. Both inputs have same sign, and result has different sign.
        // 2. Or, looking at the carry bit into/out of the MSB.
        // Simplified check:
        if ((a[7] == b[7]) && (sum_signed[7] != a[7])) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end
endmodule
