module TopModule(
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
        for (int i = 0; i < 5; i = i + 1) begin
            for (int j = 0; j < 5; j = j + 1) begin
                // out[24] = in[4] == in[4], out[23] = in[4] == in[3], ...
                // The index calculation:
                // i goes from 0 (a) to 4 (e)
                // j goes from 0 (a) to 4 (e)
                // The bit position for (in[4-i], in[4-j]) is 24 - (i * 5 + j)
                out[24 - (i * 5 + j)] = ~(in[4 - i] ^ in[4 - j]);
            end
        end
    end
endmodule
