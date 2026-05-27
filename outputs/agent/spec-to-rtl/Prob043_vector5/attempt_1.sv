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
                // The problem states: out[24] = ~(a^a) which is 1 if a==a.
                // Wait, the formula given is "~a ^ b".
                // Let's re-read: "The output should be 1 if the two bits being compared are equal."
                // ~a ^ b is actually (a == b). Let's verify.
                // If a=0, b=0: ~0 ^ 0 = 1 ^ 0 = 1. (Correct)
                // If a=0, b=1: ~0 ^ 1 = 1 ^ 1 = 0. (Correct)
                // If a=1, b=0: ~1 ^ 0 = 0 ^ 0 = 0. (Correct)
                // If a=1, b=1: ~1 ^ 1 = 0 ^ 1 = 1. (Correct)
                // Yes, ~x ^ y is the XNOR operation (x == y).
                
                // Index mapping:
                // out[24] corresponds to pair (a, a) i=0, j=0
                // out[23] corresponds to pair (a, b) i=0, j=1
                // ...
                // out[0] corresponds to pair (e, e) i=4, j=4
                out[(4-i)*5 + (4-j)] = ~(inputs[4-i] ^ inputs[4-j]);
            end
        end
    end
endmodule
