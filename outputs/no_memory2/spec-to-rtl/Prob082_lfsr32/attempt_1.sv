module TopModule (
    input logic clk,
    input logic reset,
    output logic [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Galois LFSR shift right logic:
            // next_q[i-1] = q[i] ^ (has_tap[i] ? q[0] : 0)
            // Taps at 32, 22, 2, 1 (indices 31, 21, 1, 0)
            // The feedback bit is q[0]
            // For bit 31: next_q[31] = 0 ^ (has_tap[32] ? q[0] : 0) = q[0]
            // For bit 30: next_q[30] = q[31]
            // ...
            // For bit 21: next_q[21] = q[22] ^ (has_tap[22] ? q[0] : 0) = q[22] ^ q[0]
            // ...
            // For bit 1:  next_q[1]  = q[2] ^ (has_tap[2] ? q[0] : 0)  = q[2] ^ q[0]
            // For bit 0:  next_q[0]  = q[1] ^ (has_tap[1] ? q[0] : 0)  = q[1] ^ q[0]
            
            q[31] <= q[0];
            q[30:22] <= q[31:23];
            q[21] <= q[22] ^ q[0];
            q[20:2] <= q[21:3];
            q[1] <= q[2] ^ q[0];
            q[0] <= q[1] ^ q[0];
        end
    end
endmodule
