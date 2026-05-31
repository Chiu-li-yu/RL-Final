module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output logic out
);

    logic w1;
    always @(*) begin
        // Two-input XNOR connected to 'in1' and 'in2'
        w1 = ~(in1 ^ in2);
        // XOR with 'in3'
        out = w1 ^ in3;
    end

endmodule
