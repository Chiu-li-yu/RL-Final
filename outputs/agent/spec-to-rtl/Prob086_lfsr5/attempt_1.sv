module TopModule (
    input clk,
    input reset,
    output logic [4:0] q
);

    // Galois LFSR: 
    // Shift right: q[n-1] -> q[n-2], ..., q[1] -> q[0]
    // Taps at bit positions 5 and 3 (assuming 1-based indexing in spec, 
    // corresponds to q[4] and q[2] in 0-based indexing).
    // The feedback is usually:
    // next_q[4] = q[0]
    // next_q[3] = q[4]
    // next_q[2] = q[3] ^ q[0]
    // next_q[1] = q[2]
    // next_q[0] = q[1]
    
    // Let's re-verify:
    // If bits are [4, 3, 2, 1, 0]
    // Taps at 5 and 3 (1-based) mean bit 4 (tap) and bit 2 (tap).
    // In Galois LFSR:
    // next_q[4] = q[0]
    // next_q[3] = q[4]
    // next_q[2] = q[3] ^ q[0]
    // next_q[1] = q[2]
    // next_q[0] = q[1]

    logic [4:0] next_q;

    always @(*) begin
        next_q[4] = q[0];
        next_q[3] = q[4];
        next_q[2] = q[3] ^ q[0];
        next_q[1] = q[2];
        next_q[0] = q[1];
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            q <= next_q;
        end
    end

endmodule
