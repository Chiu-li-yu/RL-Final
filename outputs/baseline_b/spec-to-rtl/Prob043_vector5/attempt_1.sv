module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    input logic e,
    output logic [24:0] out
);

    logic [4:0] inputs;
    assign inputs = {a, b, c, d, e};

    always @(*) begin
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 5; j++) begin
                // The problem states: out[24] = ~(a^a), out[23] = ~(a^b)...
                // This is equivalent to (input_i == input_j)
                out[24 - (i * 5 + j)] = (inputs[4 - i] == inputs[4 - j]);
            end
        end
    end

endmodule
