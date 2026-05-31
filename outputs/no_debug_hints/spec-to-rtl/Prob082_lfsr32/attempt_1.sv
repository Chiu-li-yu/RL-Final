module TopModule (
    input logic clk,
    input logic reset,
    output logic [31:0] q
);

    // Galois LFSR with taps at 32, 22, 2, 1
    // The bits are 0-indexed: q[0] to q[31]
    // Polynomial: x^32 + x^22 + x^2 + x^1 + 1
    // In Galois configuration, for a right shift:
    // next_q[i] = q[i+1] ^ (tap[i] ? q[0] : 0)
    // The last bit next_q[31] = 0 ^ (tap[31] ? q[0] : 0)

    logic [31:0] next_q;

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

    always_comb begin
        // Taps at positions 32, 22, 2, 1
        // Mapping to 0-indexed bits:
        // Position 32 (bit 31)
        // Position 22 (bit 21)
        // Position 2  (bit 1)
        // Position 1  (bit 0)

        // Galois shift right logic:
        // For each bit i (0 to 30): next_q[i] = q[i+1]
        // If bit i is a tap, XOR with q[0]
        
        // Let's re-verify the standard Galois LFSR right-shift implementation:
        // next_q[i] = q[i+1] ^ (tap[i+1] ? q[0] : 1'b0)
        // next_q[31] = q[0] (because tap at 32)
        
        // Tap positions are 32, 22, 2, 1 (1-indexed)
        // Corresponds to bit indices: 31, 21, 1, 0
        
        next_q[0]  = q[1] ^ q[0];      // Tap at 1
        next_q[1]  = q[2] ^ q[0];      // Tap at 2
        next_q[2]  = q[3];
        next_q[3]  = q[4];
        next_q[4]  = q[5];
        next_q[5]  = q[6];
        next_q[6]  = q[7];
        next_q[7]  = q[8];
        next_q[8]  = q[9];
        next_q[9]  = q[10];
        next_q[10] = q[11];
        next_q[11] = q[12];
        next_q[12] = q[13];
        next_q[13] = q[14];
        next_q[14] = q[15];
        next_q[15] = q[16];
        next_q[16] = q[17];
        next_q[17] = q[18];
        next_q[18] = q[19];
        next_q[19] = q[20];
        next_q[20] = q[21];
        next_q[21] = q[22] ^ q[0];     // Tap at 22
        next_q[22] = q[23];
        next_q[23] = q[24];
        next_q[24] = q[25];
        next_q[25] = q[26];
        next_q[26] = q[27];
        next_q[27] = q[28];
        next_q[28] = q[29];
        next_q[29] = q[30];
        next_q[30] = q[31];
        next_q[31] = q[0];             // Tap at 32
    end
endmodule
