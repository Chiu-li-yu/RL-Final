module TopModule (
    input logic clk,
    input logic reset,
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
        // Galois LFSR shift right:
        // Feedback bit is q[0]
        // Taps: bit positions 32, 22, 2, 1 (using 0-indexed: 31, 21, 1, 0)
        // Actually, the problem says "taps at 32, 22, 2, 1" (1-indexed).
        // 0-indexed equivalents: 31, 21, 1, 0
        
        logic lsb;
        lsb = q[0];

        // Shift right: q_next[i-1] = q[i]
        // If tap at i, q_next[i-1] = q[i] ^ lsb
        
        next_q[30] = q[31];
        next_q[29] = q[30];
        next_q[28] = q[29];
        next_q[27] = q[28];
        next_q[26] = q[27];
        next_q[25] = q[26];
        next_q[24] = q[25];
        next_q[23] = q[24];
        next_q[22] = q[23];
        next_q[21] = q[22] ^ lsb; // Tap at 22 (index 21)
        next_q[20] = q[21];
        next_q[19] = q[20];
        next_q[18] = q[19];
        next_q[17] = q[18];
        next_q[16] = q[17];
        next_q[15] = q[16];
        next_q[14] = q[15];
        next_q[13] = q[14];
        next_q[12] = q[13];
        next_q[11] = q[12];
        next_q[10] = q[11];
        next_q[9] = q[10];
        next_q[8] = q[9];
        next_q[7] = q[8];
        next_q[6] = q[7];
        next_q[5] = q[6];
        next_q[4] = q[5];
        next_q[3] = q[4];
        next_q[2] = q[3];
        next_q[1] = q[2] ^ lsb;   // Tap at 2 (index 1)
        next_q[0] = q[1] ^ lsb;   // Tap at 1 (index 0)
        next_q[31] = 1'b0 ^ lsb;  // Tap at 32 (index 31)
    end
endmodule