module TopModule (
    input clk,
    input reset,
    output logic [31:0] q
);
    // Based on standard Galois LFSR implementation:
    // next_q[i] = q[i+1] ^ (tap[i] ? q[0] : 0)
    // next_q[31] = (tap[31] ? q[0] : 0)
    
    // Tap positions 32, 22, 2, 1 correspond to bits 31, 21, 1, 0.
    // So bits 31, 21, 1, 0 are taps.
    
    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q[31] <= (q[0] ^ 1'b0); // Tap 32
            q[30] <= q[31];
            q[29] <= q[30];
            q[28] <= q[29];
            q[27] <= q[28];
            q[26] <= q[27];
            q[25] <= q[26];
            q[24] <= q[25];
            q[23] <= q[24];
            q[22] <= q[23];
            q[21] <= q[22] ^ q[0]; // Tap 22
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
            q[2] <= q[3];
            q[1] <= q[2] ^ q[0]; // Tap 2
            q[0] <= q[1] ^ q[0]; // Tap 1
        end
    end
endmodule
