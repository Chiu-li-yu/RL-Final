module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // XNOR truth table:
    // in1 | in2 | in1 ~^ in2
    // 0   | 0   | 1
    // 0   | 1   | 0
    // 1   | 0   | 0
    // 1   | 1   | 1

    // XOR truth table:
    // A   | B   | A ^ B
    // 0   | 0   | 0
    // 0   | 1   | 1
    // 1   | 0   | 1
    // 1   | 1   | 0
    
    logic w1;
    always @(*) begin
        w1 = ~(in1 ^ in2);
        out = w1 ^ in3;
    end

endmodule
