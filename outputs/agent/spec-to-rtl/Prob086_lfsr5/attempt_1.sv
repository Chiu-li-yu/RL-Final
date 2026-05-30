module TopModule (
    input clk,
    input reset,
    output logic [4:0] q
);
    // 5-bit Galois LFSR, taps at 5 and 3.
    // Positions are 1-based (bit 5, bit 3).
    // In 0-indexed terms, bit 5 is index 4, bit 3 is index 2.
    // Next state logic:
    // q_next[4] = q[0]
    // q_next[3] = q[4]
    // q_next[2] = q[3] ^ q[0]
    // q_next[1] = q[2]
    // q_next[0] = q[1]

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'd1;
        end else begin
            q[4] <= q[0];
            q[3] <= q[4];
            q[2] <= q[3] ^ q[0];
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end
endmodule
