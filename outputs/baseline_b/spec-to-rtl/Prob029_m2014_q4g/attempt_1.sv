module TopModule (
    input logic in1,
    input logic in2,
    input logic in3,
    output logic out
);

    logic xnor_out;

    always @(*) begin
        // XNOR of in1 and in2
        xnor_out = ~(in1 ^ in2);
        // XOR of xnor_out and in3
        out = xnor_out ^ in3;
    end

endmodule
