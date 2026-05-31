module TopModule (
    input clk,
    input reset,
    output logic [4:0] q
);

    logic [4:0] next_q;

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 5'd1;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        // Galois LFSR shift right
        // Taps at bit positions 5 and 3 (1-indexed based on spec logic)
        // For a 5-bit register q[4:0]:
        // q[0] is the LSB
        // Tap at 5 implies XOR with q[4]
        // Tap at 3 implies XOR with q[2] (if indices are 1-based: bit 5=q[4], bit 3=q[2])
        
        // LFSR logic:
        // next_bit = q[0]
        // q[4]   = next_bit ^ q[4] (if tap at 5)
        // q[3]   = q[4]
        // q[2]   = next_bit ^ q[2] (if tap at 3)
        // q[1]   = q[1]
        // q[0]   = q[1]
        // Wait, standard Galois shift right is:
        // bit 0 becomes the new input.
        // next_q[4] = q[0]
        // next_q[3] = q[4]
        // next_q[2] = q[3] ^ q[0] (tap at 3)
        // next_q[1] = q[2]
        // next_q[0] = q[1] ^ q[0] (tap at 5) ... wait, this is confusing.

        // Re-reading: "a bit position with a 'tap' is XORed with the LSB output bit (q[0])"
        // Let's assume bits are q[4] q[3] q[2] q[1] q[0]
        // Taps at 5 and 3 (1-indexed). Let's map to 0-indexed: bit 5 -> q[4], bit 3 -> q[2].
        // Next state logic:
        // next_q[4] = 0 ^ q[0] (if tap at 5, bit 4 is XORed with LSB)
        // next_q[3] = q[4]
        // next_q[2] = q[3] ^ q[0] (if tap at 3, bit 2 is XORed with LSB)
        // next_q[1] = q[2]
        // next_q[0] = q[1]
        
        next_q[4] = q[0];
        next_q[3] = q[4];
        next_q[2] = q[3] ^ q[0];
        next_q[1] = q[2];
        next_q[0] = q[1] ^ q[0];
    end
endmodule
