module TopModule(
    input clk,
    input reset,
    output logic [4:0] q
);

    logic [4:0] next_q;

    always @(*) begin
        // Galois LFSR shift logic
        // Standard shift right: q[4:1] = q[3:0] (no, wait)
        // Galois LFSR shifts right.
        // next_q[4] = 0 ^ q[0] (if tap at 5? wait, the problem says bits 5 and 3)
        // 5-bit LFSR has bits 4, 3, 2, 1, 0.
        // "Taps at bit positions 5 and 3" usually refer to the feedback polynomial.
        // For a 5-bit LFSR, taps at 5 and 3 typically mean:
        // x^5 + x^3 + 1.
        // In Galois LFSR, the shift right behavior:
        // q[0] is the output.
        // new_q[4] = q[0]
        // new_q[3] = q[4] ^ (tap_3 ? q[0] : 0)
        // ... etc.
        // Let's re-read: "a bit position with a 'tap' is XORed with the LSB output bit (q[0])"
        // This implies for positions i, next_state[i-1] = q[i] ^ (tap[i] ? q[0] : 0)
        // And next_state[4] = (tap[5] ? q[0] : 0) -- wait, 5 bit LFSR has bit 4 as MSB.
        // Standard taps for 5-bit maximal LFSR are x^5 + x^3 + 1 (bits 5 and 3 in polynomial notation).
        // This corresponds to feedback at position 4 and position 2 (0-indexed).

        next_q[4] = q[0];
        next_q[3] = q[4];
        next_q[2] = q[3] ^ q[0];
        next_q[1] = q[2];
        next_q[0] = q[1];
    end

    always @(posedge clk) begin
        if (reset)
            q <= 5'd1;
        else
            q <= next_q;
    end
endmodule
