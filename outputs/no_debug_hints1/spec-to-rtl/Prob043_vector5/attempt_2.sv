module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output logic [24:0] out
);
    logic [4:0] sigs;
    assign sigs = {a, b, c, d, e};

    // The spec says:
    // out[24] = ~a ^ a;
    // out[23] = ~a ^ b;
    // ...
    // out[0]  = ~e ^ e;
    
    // Let's re-read the equality logic:
    // "The output should be 1 if the two bits being compared are equal."
    // Example: ~a ^ b is actually a != b.
    // If a=0, b=0: ~0 ^ 0 = 1 ^ 0 = 1. (Equal)
    // If a=0, b=1: ~0 ^ 1 = 1 ^ 1 = 0. (Not equal)
    // So the expression (~x ^ y) is effectively (x == y).
    
    // Index mapping:
    // out[24] (i=0, j=0) -> a, a
    // out[23] (i=0, j=1) -> a, b
    // out[22] (i=0, j=2) -> a, c
    // out[21] (i=0, j=3) -> a, d
    // out[20] (i=0, j=4) -> a, e
    
    // out[24-k] corresponds to index (i, j) where i = k/5, j = k%5? No.
    // Let's index by 24 down to 0.
    // index 24: i=0, j=0 (a,a)
    // index 23: i=0, j=1 (a,b)
    // ...
    // index 0: i=4, j=4 (e,e)

    always @(*) begin
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 5; j++) begin
                out[24 - (i * 5 + j)] = (sigs[4 - i] == sigs[4 - j]);
            end
        end
    end
endmodule
