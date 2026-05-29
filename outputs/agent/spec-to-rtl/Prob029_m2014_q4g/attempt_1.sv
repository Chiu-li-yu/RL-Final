module TopModule (
    input in1,
    input in2,
    input in3,
    output logic out
);

    logic xnor_out;

    always @(*) begin
        xnor_out = ~(in1 ^ in2);
        out = xnor_out ^ in3;
    end

endmodule
