module TopModule (
    input clk,
    input reset,
    output logic [31:0] q
);

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Galois LFSR shift-right logic
            // The bits to XOR with q[0] are the tap positions.
            // Tap positions: 32, 22, 2, 1 (using 0-indexed: 31, 21, 1, 0)
            // Next value of q[i]:
            //   if i-1 == 31: q[31] = q[0] (always fed back)
            //   if i-1 is a tap: q[i-1] = q[i] ^ q[0]
            //   else: q[i-1] = q[i]
            
            // Standard Galois LFSR:
            // q_next[31] = q[0]
            // q_next[i] = q[i+1] ^ (q[0] if tap at i else 0)
            
            // Taps are at indices 31, 21, 1, 0.
            // Wait, standard Galois LFSR logic:
            // q[0] is the bit that shifts out.
            // Feedback is XORed into positions where taps are.
            // Let's re-verify the definition: "bit position with a 'tap' is XORed with the LSB output bit (q[0])"
            // If bit k has a tap, then q_next[k-1] = q[k] ^ q[0].
            // If bit k does not have a tap, q_next[k-1] = q[k].
            
            logic [31:0] q_next;
            q_next[31] = q[0]; // Bit 32 is always a tap? Specification says 32, 22, 2, 1.
            q_next[30] = q[31];
            q_next[29] = q[30];
            q_next[28] = q[29];
            q_next[27] = q[28];
            q_next[26] = q[27];
            q_next[25] = q[26];
            q_next[24] = q[25];
            q_next[23] = q[24];
            q_next[22] = q[23];
            q_next[21] = q[22] ^ q[0]; // Tap 22
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

            q <= q_next;
        end
    end
endmodule
