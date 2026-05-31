module TopModule (
    input clk,
    input reset,
    output logic [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Galois LFSR shift logic:
            // Taps are at 32, 22, 2, 1 (using 1-based indexing in description).
            // In 0-based indexing for 32 bits (q[31:0]), these correspond to indices:
            // 31, 21, 1, 0.
            // The feedback bit is q[0].
            // If bit i has a tap, new_q[i-1] = q[i] ^ (q[0] if tap else 0).
            // Actually, the standard Galois LFSR formula for a right-shift LFSR is:
            // next_q[31] = q[0] * tap[31]
            // next_q[i-1] = q[i] ^ (q[0] * tap[i-1])
            
            logic feedback;
            feedback = q[0];
            
            q[30:0] <= q[31:1];
            q[31] <= 1'b0; // shifted in 0
            
            if (feedback) begin
                // Taps at bit positions 32, 22, 2, 1 (1-indexed)
                // -> Indices 31, 21, 1, 0
                q[31]   ^= 1'b1;
                q[21]   ^= 1'b1;
                q[1]    ^= 1'b1;
                q[0]    ^= 1'b1;
            end
        end
    end

endmodule
