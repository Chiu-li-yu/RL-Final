module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output logic [24:0] out
);
    logic [4:0] in;
    assign in = {a, b, c, d, e};

    always @(*) begin
        // out[24] = ~(a ^ a) = a == a
        // out[23] = ~(a ^ b) = a == b
        // ...
        // out[0]  = ~(e ^ e) = e == e
        // 驗證一下題目描述：out[24] = ~a ^ a
        // 在 Verilog 中， ~a ^ a 是 (NOT a) XOR a
        // 邏輯表:
        // a | ~a | ~a ^ a
        // 0 |  1 |    1
        // 1 |  0 |    1
        // 也就是說 ~a ^ a 恆為 1 (a == a)
        // 那 ~a ^ b 就是 (NOT a) XOR b
        // 邏輯表:
        // a | b | ~a | ~a ^ b
        // 0 | 0 |  1 |   1
        // 0 | 1 |  1 |   0
        // 1 | 0 |  0 |   0
        // 1 | 1 |  0 |   1
        // 這確實就是 a == b
        
        for (int i = 0; i < 5; i = i + 1) begin
            for (int j = 0; j < 5; j = j + 1) begin
                out[24 - (i * 5 + j)] = (~in[i] ^ in[j]);
            end
        end
    end
endmodule
