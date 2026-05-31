module TopModule (
    input logic clk,
    input logic reset,
    output logic [4:0] q
);

    logic [4:0] q_next;

    always_ff @(posedge clk) begin
        if (reset)
            q <= 5'b00001;
        else
            q <= q_next;
    end

    always_comb begin
        // Galois LFSR: 5-bit, taps at 5 and 3.
        // Positions are 4, 3, 2, 1, 0 (5 bits)
        // Bit positions are 1-indexed in common LFSR theory (taps at 5 and 3),
        // which corresponds to bit 4 and bit 2 in a 0-indexed 5-bit vector.
        // Rule: If bit i has a tap, next_bit[i-1] = bit[0] ^ bit[i].
        // Else next_bit[i-1] = bit[i].
        // Special case: next_bit[4] = bit[0] (always).
        
        // Tap at 5 (index 4) and 3 (index 2)
        q_next[4] = q[0];
        q_next[3] = q[4];
        q_next[2] = q[3] ^ q[0];
        q_next[1] = q[2];
        q_next[0] = q[1];
    end

endmodule
