module TopModule (
    input clk,
    input reset,
    output logic [4:0] q
);

    // Galois LFSR: 5-bit
    // Taps at bit positions 5 and 3 (using 1-based indexing as typical in LFSR math notation)
    // For a 5-bit LFSR, bits are q[4], q[3], q[2], q[1], q[0].
    // Tap at position 5 corresponds to XORing with q[4] (or the bit shifting out)
    // Tap at position 3 corresponds to XORing with q[2]
    // Feedback polynomial x^5 + x^2 + 1 corresponds to tapping at positions 5 and 2 (in 1-based index)
    // The prompt says "taps at bit positions 5 and 3". 
    // Usually, for a 5-bit LFSR, taps at 5 and 3 (1-based) mean bits index 4 and 2.

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Galois shift right:
            // new_q[4] = 0 ^ q[0] (if tap at 5)
            // new_q[3] = q[4]
            // new_q[2] = q[3] ^ q[0] (if tap at 3)
            // new_q[1] = q[2]
            // new_q[0] = q[1]
            
            logic feedback;
            feedback = q[0];
            
            q[4] <= feedback;
            q[3] <= q[4];
            q[2] <= q[3] ^ feedback;
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end
endmodule