module TopModule (
    input clk,
    input reset,
    output logic [4:0] q
);
    // 5-bit Galois LFSR with taps at 5 and 3.
    // The bits are labeled 4, 3, 2, 1, 0.
    // Tap positions 5 and 3 refer to the bits shifted into.
    // For a 5-bit LFSR (q[4:0]), the bits are positions 4, 3, 2, 1, 0.
    // Usually, taps are defined relative to the bit being shifted out.
    // Given taps at 5 and 3 for 5 bits, it usually maps to q[4] and q[2].
    // Let's define the update logic based on standard Galois LFSR:
    // next_q[4] = 0 ^ q[0] (if tap at 5)
    // next_q[3] = q[4]
    // next_q[2] = q[3] ^ q[0] (if tap at 3)
    // next_q[1] = q[2]
    // next_q[0] = q[1]

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            q[4] <= q[0];
            q[3] <= q[4];
            q[2] <= q[3] ^ q[0];
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end
endmodule
