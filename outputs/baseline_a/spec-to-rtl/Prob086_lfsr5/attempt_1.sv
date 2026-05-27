module TopModule (
    input logic clk,
    input logic reset,
    output logic [4:0] q
);

    // 5-bit Galois LFSR with taps at positions 5 and 3 (0-indexed: 4 and 2).
    // The feedback logic for bit 0 is always XORed with q[0].
    // For a 5-bit LFSR (q[4:0]), the next state logic:
    // next_q[4]   = q[0]
    // next_q[3]   = q[4]
    // next_q[2]   = q[3] ^ q[0]
    // next_q[1]   = q[2]
    // next_q[0]   = q[1]

    always @(posedge clk) begin
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
