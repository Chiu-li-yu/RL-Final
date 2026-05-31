module TopModule (
    input clk,
    input reset,
    output logic [31:0] q
);

    // Galois LFSR:
    // Bits [31:0]. Shift right.
    // Feedback bit is q[0].
    // Tap positions: 32, 22, 2, 1
    // Represented in 0-indexed [31:0]: 
    // Bit 32 is q[31], 22 is q[21], 2 is q[1], 1 is q[0]
    
    // Galois logic:
    // next_q[i] = q[i+1] ^ (tap_i ? q[0] : 0)
    // next_q[31] = q[0]
    
    logic [31:0] next_q;

    always @(*) begin
        // bit 31 (tap 32)
        next_q[31] = q[0];
        // bit 30
        next_q[30] = q[31];
        // ...
        // bit 22 (tap 22 is index 21)
        next_q[21] = q[22] ^ q[0];
        // bit 2 (tap 2 is index 1)
        next_q[1] = q[2] ^ q[0];
        // bit 1 (tap 1 is index 0)
        next_q[0] = q[1] ^ q[0];
        
        // Fill the rest
        next_q[30:22] = q[31:23];
        next_q[20:2] = q[21:3];
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end
endmodule
