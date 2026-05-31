module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic q
);

    always @(*) begin
        // Perform a Karnaugh map analysis based on the truth table:
        // Inputs: a, b, c, d
        // Output q=1 when:
        // 0000 -> 1
        // 0011 -> 1
        // 0101 -> 1
        // 0110 -> 1
        // 1001 -> 1
        // 1010 -> 1
        // 1100 -> 1
        // 1111 -> 1
        
        // This is an XNOR / XOR parity-like pattern.
        // It's the condition where the number of inputs that are 1 is even.
        // Or simply q = ~(a ^ b ^ c ^ d)
        
        q = ~(a ^ b ^ c ^ d);
    end

endmodule