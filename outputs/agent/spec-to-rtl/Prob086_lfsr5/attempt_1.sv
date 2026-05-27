module TopModule (
    input logic clk,
    input logic reset,
    output logic [4:0] q
);

    // 5-bit Galois LFSR with taps at positions 5 and 3 (0-indexed: 4 and 2)
    // For a 5-bit register (q[4:0]), taps at 5 and 3 means the bits 
    // are q[4] and q[2].
    // Shift logic for Galois LFSR:
    // next_q[4] = q[0] ^ 0 (since q[4] is a tap, 0 is assumed bit 5)
    // next_q[3] = q[4]
    // next_q[2] = q[3] ^ q[0] (since q[2] is a tap)
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
