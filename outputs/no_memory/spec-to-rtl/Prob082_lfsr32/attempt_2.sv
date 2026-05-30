module TopModule(
    input clk,
    input reset,
    output logic [31:0] q
);

    logic [31:0] next_q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        // Galois LFSR behavior:
        // Taps at bit positions 32, 22, 2, 1 (1-based index)
        // Which correspond to bit indices 31, 21, 1, 0 (0-based)
        // next_q[i-1] = q[i] ^ (tap ? q[0] : 0)
        
        // Bit index 31: next_q[31] = 0 ^ q[0]
        // Bit index 21: next_q[21] = q[22] ^ q[0]
        // Bit index 1:  next_q[1]  = q[2] ^ q[0]
        // Bit index 0:  next_q[0]  = q[1] ^ q[0]
        
        // Shift right default
        next_q[31] = q[0]; // tap at 32
        next_q[30:22] = q[31:23];
        next_q[21] = q[22] ^ q[0]; // tap at 22
        next_q[20:2] = q[21:3];
        next_q[1] = q[2] ^ q[0]; // tap at 2
        next_q[0] = q[1] ^ q[0]; // tap at 1
    end

endmodule
