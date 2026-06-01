module TopModule (
    input clk,
    input reset,
    output logic [31:0] q
);

    // Galois LFSR with taps at 32, 22, 2, 1
    // In 0-indexed notation, this corresponds to positions 31, 21, 1, 0.
    // The feedback polynomial is x^32 + x^22 + x^2 + x^1 + 1.
    // Galois LFSR update rule:
    // next_q[31] = q[0]
    // next_q[i] = q[i+1] ^ (q[0] if tap at i+1)
    
    // Taps are at 32, 22, 2, 1.
    // Bit 31 gets q[0] ^ 0 (implied tap at 32)
    // Bit 21 gets q[22] ^ q[0] (tap at 22)
    // Bit 1 gets q[2] ^ q[0] (tap at 2)
    // Bit 0 gets q[1] ^ q[0] (tap at 1)

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Galois LFSR logic
            // q[0] is the output of the shift
            // If bit is a tap, new_bit = old_bit_next ^ q[0]
            // If bit is not a tap, new_bit = old_bit_next
            // For bit 31, it's a special case, next_q[31] = q[0]
            
            q[31] <= q[0];
            q[30] <= q[31];
            q[29] <= q[30];
            q[28] <= q[29];
            q[27] <= q[28];
            q[26] <= q[27];
            q[25] <= q[26];
            q[24] <= q[25];
            q[23] <= q[24];
            q[22] <= q[23] ^ q[0]; // Tap 22
            q[21] <= q[22];
            q[20] <= q[21];
            q[19] <= q[20];
            q[18] <= q[19];
            q[17] <= q[18];
            q[16] <= q[17];
            q[15] <= q[16];
            q[14] <= q[15];
            q[13] <= q[14];
            q[12] <= q[13];
            q[11] <= q[12];
            q[10] <= q[11];
            q[9] <= q[10];
            q[8] <= q[9];
            q[7] <= q[8];
            q[6] <= q[7];
            q[5] <= q[6];
            q[4] <= q[5];
            q[3] <= q[4];
            q[2] <= q[3] ^ q[0]; // Tap 2
            q[1] <= q[2] ^ q[0]; // Tap 1
            q[0] <= q[1];
        end
    end

endmodule
