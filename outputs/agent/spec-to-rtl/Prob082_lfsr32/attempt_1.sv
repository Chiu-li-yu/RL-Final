module TopModule (
    input clk,
    input reset,
    output logic [31:0] q
);

    // 32-bit Galois LFSR with taps at positions 32, 22, 2, 1.
    // The bits are 0-indexed: q[31], q[30], ..., q[0].
    // Tap positions 32, 22, 2, 1 correspond to indices 31, 21, 1, 0.
    // For a right-shifting Galois LFSR:
    // next_q[i] = q[i+1] XOR (q[0] if tap at i+1)
    // next_q[31] = 0 XOR (q[0] if tap at 32) -> next_q[31] = q[0]
    // The tap at bit 32 corresponds to the XOR into the MSB (q[31]).
    // The other taps (22, 2, 1) correspond to indices 21, 1, 0.
    
    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right logic
            // New q[31] = q[0]
            // New q[21] = q[22] ^ q[0]
            // New q[1]  = q[2] ^ q[0]
            // New q[0]  = q[1] ^ q[0]
            // Others   = q[i+1]
            
            q[31]    <= q[0];
            q[30:22] <= q[31:23];
            q[21]    <= q[22] ^ q[0];
            q[20:2]  <= q[21:3];
            q[1]     <= q[2] ^ q[0];
            q[0]     <= q[1] ^ q[0];
        end
    end

endmodule
