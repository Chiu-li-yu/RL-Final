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
                // out[24 - (i*5 + j)] = inputs[i] == inputs[j]
                // 題目說明: out[24] = ~a ^ a (即 a == a ? 1 : 0)
                // 題目說明: out[23] = ~a ^ b (即 a == b ? 1 : 0)
                // 順序是 i 跑 0~4, j 跑 0~4
                // i=0 (a), j=0 (a) -> out[24]
                // i=0 (a), j=1 (b) -> out[23]
                // i=4 (e), j=4 (e) -> out[0]
                out[24 - (i * 5 + j)] = (inputs[i] == inputs[j]);
            end
        end
    end
endmodule
