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
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 5; j++) begin
                // The requirement: out[idx] = ~(inputs[i] ^ inputs[j])
                // Which is inputs[i] == inputs[j]
                out[i * 5 + j] = (inputs[4 - i] == inputs[4 - j]);
            end
        end
    end
endmodule
