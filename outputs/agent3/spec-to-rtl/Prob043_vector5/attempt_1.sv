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
        // out[24] = ~(a ^ a)  = a == a
        // out[23] = ~(a ^ b)  = a == b
        // ...
        // out[20] = ~(a ^ e)  = a == e
        // out[19] = ~(b ^ a)  = b == a
        // ...
        
        // The spec says: out[24] = ~a ^ a
        // In Verilog, ~a ^ a is always 1 (true) if a is 0 or 1.
        // Wait, let's re-read: "The output should be 1 if the two bits being compared are equal."
        // Example: out[24] = ~a ^ a. If a=0, ~a=1, 1^0=1. If a=1, ~a=0, 0^1=1.
        // So the example given "~a ^ a" is logically equivalent to (a == a).
        // Let's implement comparing bits i and j.
        
        for (int i = 0; i < 5; i = i + 1) begin
            for (int j = 0; j < 5; j = j + 1) begin
                // mapping:
                // i=0 (a), j=0 (a) -> out[24]
                // i=0 (a), j=1 (b) -> out[23]
                // i=4 (e), j=4 (e) -> out[0]
                // index = (4-i)*5 + (4-j)
                out[(4-i)*5 + (4-j)] = ~(inputs[4-i] ^ inputs[4-j]);
            end
        end
    end
endmodule
