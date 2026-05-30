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
                // index for out:
                // i=0 (a): out[24]..out[20]
                // i=1 (b): out[19]..out[15]
                // ...
                // Formula: 24 - (i*5 + j)
                out[24 - (i * 5 + j)] = ~(inputs[4 - i] ^ inputs[4 - j]);
            end
        end
    end
endmodule
