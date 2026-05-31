module TopModule (
    input clk,
    input reset,
    output logic [4:0] q
);
    // 5-bit Galois LFSR, taps at bit positions 5 and 3 (1-based index).
    // In 0-based index: 
    // Tap at position 5 -> index 4
    // Tap at position 3 -> index 2
    // Galois LFSR shift right:
    // next_q[4] = 0 ^ (q[0] == 1 ? 1'b1 : 1'b0) // q[0] XOR bit 4
    // next_q[3] = q[4]
    // next_q[2] = q[3] ^ (q[0] == 1 ? 1'b1 : 1'b0) // q[0] XOR bit 2
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
