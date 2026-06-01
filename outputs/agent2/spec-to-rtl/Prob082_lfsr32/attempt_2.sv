module TopModule (
    input clk,
    input reset,
    output logic [31:0] q
);

    // Galois LFSR:
    // Bits are [31:0]. Shift right.
    // Tap positions 32, 22, 2, 1 correspond to bits 31, 21, 1, 0.
    // The feedback polynomial is x^32 + x^22 + x^2 + x^1 + 1.
    // 
    // Logic:
    // next_q[i-1] = (tap_i ? q[i] ^ q[0] : q[i])
    // With tap at 32 (index 31), 22 (index 21), 2 (index 1), 1 (index 0).
    //
    // Simplified logic for Galois LFSR with feedback polynomial:
    // next_q = {q[0], q[31:1]} ^ ({32{q[0]}} & 32'b00000000010000000000000000000111)
    // Wait, tap 32 (pos 31), 22 (pos 21), 2 (pos 1), 1 (pos 0).
    // The feedback mask should have 1s at positions 31, 21, 1, 0.
    
    logic [31:0] next_q;

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

    always_comb begin
        next_q = {q[0], q[31:1]};
        if (q[0]) begin
            next_q[31] ^= 1; // Tap 32
            next_q[21] ^= 1; // Tap 22
            next_q[1]  ^= 1; // Tap 2
            next_q[0]  ^= 1; // Tap 1
        end
    end

endmodule
