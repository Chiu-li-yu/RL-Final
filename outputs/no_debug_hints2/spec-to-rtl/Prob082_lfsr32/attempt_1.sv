module TopModule(
    input clk,
    input reset,
    output logic [31:0] q
);

    // Galois LFSR behavior:
    // Bits shift right.
    // Taps at 32, 22, 2, 1 (using 1-based indexing as specified).
    // In a 0-based 32-bit register (q[31:0]), the bits are 31 down to 0.
    // Tap at bit position n (1-based) corresponds to index n-1.
    // So taps are at indices 31, 21, 1, 0.
    // The feedback bit is the current LSB (q[0]).
    // Next state:
    // q_new[30] = q[31] ^ q[0] (tap 32)
    // q_new[20] = q[21] ^ q[0] (tap 22)
    // q_new[0]  = q[1]  ^ q[0] (tap 2)
    // q_new[31] = q[0]         (tap 1 - LSB feeds back)
    
    // Correction: Standard Galois LFSR definition for taps {32, 22, 2, 1}
    // means q[31] is the MSB.
    // If bit position 32 is a tap, and we shift right, it means
    // q_next[31] = (0 ^ q[0]) = q[0]
    // q_next[n-1] = q[n] ^ (is_tap ? q[0] : 0)
    
    logic [31:0] q_next;

    always_comb begin
        q_next[31] = q[0];
        q_next[30] = q[31];
        q_next[29] = q[30];
        q_next[28] = q[29];
        q_next[27] = q[28];
        q_next[26] = q[27];
        q_next[25] = q[26];
        q_next[24] = q[25];
        q_next[23] = q[24];
        q_next[22] = q[23] ^ q[0]; // Tap 22
        q_next[21] = q[22];
        q_next[20] = q[21];
        q_next[19] = q[20];
        q_next[18] = q[19];
        q_next[17] = q[18];
        q_next[16] = q[17];
        q_next[15] = q[16];
        q_next[14] = q[15];
        q_next[13] = q[14];
        q_next[12] = q[13];
        q_next[11] = q[12];
        q_next[10] = q[11];
        q_next[9] = q[10];
        q_next[8] = q[9];
        q_next[7] = q[8];
        q_next[6] = q[7];
        q_next[5] = q[6];
        q_next[4] = q[5];
        q_next[3] = q[4];
        q_next[2] = q[3] ^ q[0]; // Tap 2
        q_next[1] = q[2] ^ q[0]; // Tap 1
        q_next[0] = q[1];
    end

    always_ff @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= q_next;
    end

endmodule
