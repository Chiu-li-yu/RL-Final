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
            // Taps are at 32, 22, 2, 1 (1-indexed).
            // Indices: 31, 21, 1, 0.
            // Next state logic:
            // next_q[30:0] = q[31:1]
            // next_q[31] = q[0]
            // For taps at 31, 21, 1, 0:
            // q[i-1] = (q[i] ^ q[0]) if tap exists at i
            // Specifically for right shift LFSR:
            // q[n-1] = q[n] ^ (q[0] * tap[n])
            
            logic feedback;
            feedback = q[0];
            
            q[31] <= feedback;
            q[30] <= q[31];
            q[29] <= q[30];
            q[28] <= q[29];
            q[27] <= q[28];
            q[26] <= q[27];
            q[25] <= q[26];
            q[24] <= q[25];
            q[23] <= q[24];
            q[22] <= q[23];
            q[21] <= q[22] ^ feedback; // Tap at 22
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
            q[9]  <= q[10];
            q[8]  <= q[9];
            q[7]  <= q[8];
            q[6]  <= q[7];
            q[5]  <= q[6];
            q[4]  <= q[5];
            q[3]  <= q[4];
            q[2]  <= q[3] ^ feedback; // Tap at 2
            q[1]  <= q[2] ^ feedback; // Tap at 1
            q[0]  <= q[1];
        end
    end
endmodule
