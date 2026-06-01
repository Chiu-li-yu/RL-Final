module TopModule (
    input clk,
    input reset,
    output logic [31:0] q
);

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Galois LFSR:
            // The feedback bit is q[0].
            // For a 32-bit register where q[0] is the LSB and shifts out.
            // New q[31] = q[0] ^ (taps_at_31 ? q[0] : 0) ? No.
            // Standard Galois LFSR formula:
            // next_q[i] = q[i+1] ^ (q[0] if tap at i+1 else 0)
            // next_q[31] = q[0] if tap at 32 else 0.
            
            // Taps at 32, 22, 2, 1.
            // q[0] shifts out.
            // q[31] = 0 ^ (q[0] if tap 32 else 0) = q[0]
            // q[21] = q[22] ^ (q[0] if tap 22 else 0) = q[22] ^ q[0]
            // q[1] = q[2] ^ (q[0] if tap 2 else 0) = q[2] ^ q[0]
            // q[0] = q[1] ^ (q[0] if tap 1 else 0) = q[1] ^ q[0]
            
            // Let's implement this:
            logic [31:0] next_q;
            next_q[31] = q[0];            // Tap 32
            next_q[30:22] = q[31:23];
            next_q[21] = q[22] ^ q[0];    // Tap 22
            next_q[20:2] = q[21:3];
            next_q[1] = q[2] ^ q[0];      // Tap 2
            next_q[0] = q[1] ^ q[0];      // Tap 1
            
            q <= next_q;
        end
    end
endmodule
