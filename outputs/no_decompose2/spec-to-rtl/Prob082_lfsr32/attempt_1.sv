module TopModule(
    input clk,
    input reset,
    output logic [31:0] q
);
    logic [31:0] next_q;

    always_ff @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

    always_comb begin
        // Galois LFSR shift right
        // Taps at bit positions 32 (implied input), 22, 2, 1 (using 0-indexed: 31, 21, 1, 0)
        // For a 32-bit register q[31:0]
        // Next state = {0, q[31:1]} XOR (q[0] ? taps_mask : 0)
        
        logic [31:0] taps;
        taps = 32'b0;
        taps[31] = 1'b1; // Position 32 (0-index 31)
        taps[21] = 1'b1; // Position 22 (0-index 21)
        taps[1]  = 1'b1; // Position 2  (0-index 1)
        taps[0]  = 1'b1; // Position 1  (0-index 0)

        if (q[0])
            next_q = (q >> 1) ^ (taps >> 1);
        else
            next_q = (q >> 1);
    end
endmodule