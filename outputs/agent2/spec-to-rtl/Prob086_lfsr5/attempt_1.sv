module TopModule (
    input clk,
    input reset,
    output logic [4:0] q
);
    // 5-bit Galois LFSR with taps at 5 and 3
    // Since bits are 0-indexed (4, 3, 2, 1, 0), tap at 5 corresponds to index 4, and tap at 3 corresponds to index 2.
    // Galois LFSR state update:
    // next_q[4] = 0 ^ q[0]
    // next_q[3] = q[4]
    // next_q[2] = q[3] ^ q[0]
    // next_q[1] = q[2]
    // next_q[0] = q[1]

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            q[4] <= q[0];
            q[3] <= q[4];
            q[2] <= q[3] ^ q[0];
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end
endmodule
