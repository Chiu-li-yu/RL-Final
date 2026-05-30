module TopModule (
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

    always_comb begin
        // Galois LFSR behavior:
        // Shifts right (q[i] = q[i+1])
        // If tap exists at bit i: next_q[i] = q[i+1] ^ q[0]
        // Else: next_q[i] = q[i+1]
        // Taps are at 32, 22, 2, 1.
        // Since we are doing a 32-bit register q[31:0], bit positions 1-indexed:
        // Position 32 is q[31], Position 22 is q[21], Position 2 is q[1], Position 1 is q[0].
        
        // LFSR polynomial taps usually defined as indices of the bits being XORed.
        // For a 32-bit LFSR with taps at 32, 22, 2, 1:
        // next_q[i] = q[i-1] for most.
        // For taps, XOR with q[0].
        // With shift right:
        // q[31] becomes 0 ^ q[0] (if tap 32)
        // q[21] becomes q[22] ^ q[0] (if tap 22)
        // q[1] becomes q[2] ^ q[0] (if tap 2)
        // q[0] becomes q[1] ^ q[0] (if tap 1)

        next_q[31] = q[0]; // tap at 32
        next_q[30:22] = q[31:23];
        next_q[21] = q[22] ^ q[0]; // tap at 22
        next_q[20:2] = q[21:3];
        next_q[1] = q[2] ^ q[0]; // tap at 2
        next_q[0] = q[1] ^ q[0]; // tap at 1
    end

endmodule
