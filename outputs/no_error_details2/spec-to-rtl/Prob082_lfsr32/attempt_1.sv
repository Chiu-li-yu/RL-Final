module TopModule (
    input clk,
    input reset,
    output logic [31:0] q
);

    // Galois LFSR:
    // Taps at bit positions 32, 22, 2, and 1.
    // In a 0-indexed 32-bit register (bits 31 down to 0):
    // Position 32 corresponds to the feedback into the MSB.
    // Position 22 corresponds to index 21.
    // Position 2 corresponds to index 1.
    // Position 1 corresponds to index 0.
    
    // The rule for Galois LFSR shift-right:
    // next_q[i] = q[i+1] (if not tap)
    // next_q[i] = q[i+1] ^ q[0] (if tap)
    // The MSB (q[31]) is q[0] (since tap at 32).

    logic [31:0] next_q;

    always @(*) begin
        next_q[31] = q[0];            // Tap 32
        next_q[30:22] = q[31:23];     // No tap
        next_q[21] = q[22] ^ q[0];    // Tap 22 (index 21)
        next_q[20:2] = q[21:3];       // No tap
        next_q[1] = q[2] ^ q[0];      // Tap 2 (index 1)
        next_q[0] = q[1] ^ q[0];      // Tap 1 (index 0)
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule