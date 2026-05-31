module TopModule(
    input clk,
    input reset,
    output logic [31:0] q
);

    logic [31:0] next_q;

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        // Galois LFSR behavior:
        // Shifts right (q[i] becomes q[i-1])
        // For taps (positions 32, 22, 2, 1, 0-indexed as 31, 21, 1, 0):
        // new_bit[i] = q[i-1] ^ (q[0] if tap else 0)
        // Since it's a 32-bit register, indices are 0 to 31.
        // Taps at 32, 22, 2, 1 correspond to indices 31, 21, 1, 0.
        
        logic lsb;
        lsb = q[0];

        // Shift right
        next_q[30:0] = q[31:1];
        next_q[31] = 0 ^ lsb; // Tap at 32 (bit 31)

        // Apply taps at 22 (bit 21), 2 (bit 1), 1 (bit 0)
        // new_bit[i] = q[i-1] ^ (lsb)
        next_q[21] = q[22] ^ lsb;
        next_q[1]  = q[2] ^ lsb;
        next_q[0]  = q[1] ^ lsb;
    end

endmodule