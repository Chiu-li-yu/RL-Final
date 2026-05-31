module TopModule(
    input a,
    input b,
    input c,
    output out
);
    always @(*) begin
        // K-map breakdown:
        // a=0, bc=00 -> 0
        // a=0, bc=01 -> 1
        // a=0, bc=11 -> 1
        // a=0, bc=10 -> 1
        // a=1, bc=00 -> 1
        // a=1, bc=01 -> 1
        // a=1, bc=11 -> 1
        // a=1, bc=10 -> 1
        
        // Sum of products (minterms):
        // (a'bc') + (a'bc) + (a'b'c) + (ab'c') + (ab'c) + (abc') + (abc)
        // Simplified:
        // Out = a OR b OR c
        out = a | b | c;
    end
endmodule
