module TopModule (
    input logic in1,
    input logic in2,
    input logic in3,
    output logic out
);

    logic xnor_out;

    always @(*) begin
        // Two-input XNOR
        xnor_out = ~(in1 ^ in2);
        
        // Two-input XOR with xnor_out and in3
        out = xnor_out ^ in3;
    end

endmodule
