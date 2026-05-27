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
        // The requirement is:
        // out[24] = ~(a ^ a) = a == a
        // out[23] = ~(a ^ b) = a == b
        // ...
        // out[0]  = ~(e ^ e) = e == e
        // We can use the XNOR operation (xnor_res = ~(x ^ y)) 
        // which is equivalent to (x == y).
        
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 5; j++) begin
                // Row i (from input[4] to input[0]), Col j (from input[4] to input[0])
                // out[24] is (inputs[4] == inputs[4])
                // out[0]  is (inputs[0] == inputs[0])
                // Index mapping: index = (4-i)*5 + (4-j)
                out[(4 - i) * 5 + (4 - j)] = (inputs[4 - i] == inputs[4 - j]);
            end
        end
    end
endmodule
