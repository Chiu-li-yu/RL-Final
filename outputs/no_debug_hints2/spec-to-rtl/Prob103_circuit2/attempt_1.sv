module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Karnaugh Map analysis based on the truth table
    // q = (a^b^c^d) 
    // Let's check:
    // 0000 -> 1 (0^0^0^0 = 0 -> 1)
    // 0001 -> 0 (0^0^0^1 = 1 -> 0)
    // 0010 -> 0 (0^0^1^0 = 1 -> 0)
    // 0011 -> 1 (0^0^1^1 = 0 -> 1)
    // 0100 -> 0 (0^1^0^0 = 1 -> 0)
    // 0101 -> 1 (0^1^0^1 = 0 -> 1)
    // 0110 -> 1 (0^1^1^0 = 0 -> 1)
    // 0111 -> 0 (0^1^1^1 = 1 -> 0)
    // This matches the XNOR pattern.
    
    assign q = ~(a ^ b ^ c ^ d);
endmodule