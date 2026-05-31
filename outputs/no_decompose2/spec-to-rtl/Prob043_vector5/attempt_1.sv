module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output logic [24:0] out
);
    logic [4:0] inputs;
    assign inputs = {a, b, c, d, e};

    always @(*) begin
        for (int i = 0; i < 5; i = i + 1) begin
            for (int j = 0; j < 5; j = j + 1) begin
                // The requirement is out[24] = ~(a ^ a) (if equal, 1). 
                // Wait, the prompt says "out[24] = ~a ^ a", 
                // which is !(a ^ a) = 1 if a==a.
                // So it is the XNOR operation: ~(inputs[4-i] ^ inputs[4-j])
                out[24 - (i * 5 + j)] = ~(inputs[4 - i] ^ inputs[4 - j]);
            end
        end
    end
endmodule
