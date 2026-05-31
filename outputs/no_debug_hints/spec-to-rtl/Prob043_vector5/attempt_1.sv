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
        // out[24] corresponds to (a == a)
        // out[20] corresponds to (a == e)
        // ...
        // out[0] corresponds to (e == e)
        // The indices 24 down to 0:
        // i=0 corresponds to (a,a), i=4 corresponds to (a,e)
        // i=5 corresponds to (b,a), i=9 corresponds to (b,e)
        // ...
        for (int i = 0; i < 5; i = i + 1) begin
            for (int j = 0; j < 5; j = j + 1) begin
                out[24 - (i * 5 + j)] = (inputs[4 - i] == inputs[4 - j]);
            end
        end
    end
endmodule
