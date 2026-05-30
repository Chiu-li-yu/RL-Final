module TopModule(
    input clk,
    input reset,
    output logic [31:0] q
);

    // 32-bit Galois LFSR with taps at positions 32, 22, 2, 1.
    // In a 0-indexed 32-bit register (0 to 31):
    // Position 32 corresponds to index 31 (the bit being XORed with the LSB).
    // Taps are at indices: 31, 21, 1, 0.
    
    logic [31:0] q_next;

    always_ff @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= q_next;
    end

    always @(*) begin
        // For a Galois LFSR shifting right (from bit i to i-1):
        // q_next[i-1] = q[i] ^ (q[0] if tap at i)
        // Bit 0 shifts out.
        // New q[31] = q[0]
        
        q_next[30] = q[31];
        q_next[29] = q[30];
        q_next[28] = q[29];
        q_next[27] = q[28];
        q_next[26] = q[27];
        q_next[25] = q[26];
        q_next[24] = q[25];
        q_next[23] = q[24];
        q_next[22] = q[23] ^ q[0]; // Tap at 22 (index 21 logic?) 
        // Wait, "taps at bit positions 32, 22, 2, 1"
        // Standard definition: q[31] is bit 32.
        // Let's re-map:
        // Position 32 -> index 31
        // Position 22 -> index 21
        // Position 2  -> index 1
        // Position 1  -> index 0
    end
endmodule