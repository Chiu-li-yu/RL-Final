module TopModule (
    input clk,
    input reset,
    output logic [31:0] q
);

    // Galois LFSR: 32-bit, Taps at 32, 22, 2, 1
    // The bits are 0-indexed [31:0]. 
    // Tap positions correspond to feedback logic.
    // The standard Galois LFSR shift:
    // next_q[31] = q[0]
    // next_q[n-1] = q[n] ^ (tap ? q[0] : 0)
    
    // For a 32-bit register, the feedback taps are at positions 32, 22, 2, 1.
    // Indexing q[31:0], these correspond to:
    // q[31], q[21], q[1], q[0]
    
    logic [31:0] next_q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        next_q[31] = q[0];
        next_q[30] = q[31];
        next_q[29] = q[30];
        next_q[28] = q[29];
        next_q[27] = q[28];
        next_q[26] = q[27];
        next_q[25] = q[26];
        next_q[24] = q[25];
        next_q[23] = q[24];
        next_q[22] = q[23] ^ q[0]; // Tap at 22 (index 21) -> Wait, spec says 32, 22, 2, 1.
                                  // If index 0 is LSB, then bit 32 is q[31], 22 is q[21], 2 is q[1], 1 is q[0].
                                  // Let's re-evaluate:
    end
endmodule
