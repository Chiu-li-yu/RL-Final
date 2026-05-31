module TopModule (
    input clk,
    input reset,
    output logic [4:0] q
);

    logic [4:0] next_q;

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 5'd1;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        // Galois LFSR taps at 5 and 3 (index 4 and 2)
        // Polynomial: x^5 + x^2 + 1
        // Shift right, xor bit 0 with taps at positions 4 and 2
        // Next q[4] = q[0]
        // Next q[3] = q[4]
        // Next q[2] = q[3] ^ q[0]
        // Next q[1] = q[2]
        // Next q[0] = q[1]
        next_q[4] = q[0];
        next_q[3] = q[4];
        next_q[2] = q[3] ^ q[0];
        next_q[1] = q[2];
        next_q[0] = q[1];
    end

endmodule
