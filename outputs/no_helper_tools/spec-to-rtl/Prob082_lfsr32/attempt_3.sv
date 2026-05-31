module TopModule (
    input clk,
    input reset,
    output logic [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // The Galois LFSR polynomial is usually x^32 + x^22 + x^2 + x^1 + 1.
            // The taps are at 32, 22, 2, 1.
            // In a Galois LFSR, the register shifts right.
            // q_next[i] = q[i+1] ^ (q[0] if tap[i+1] else 0)
            // q_next[31] = q[0]
            
            logic [31:0] next_q;
            logic feedback;
            feedback = q[0];
            
            next_q[31] = feedback;
            next_q[30:22] = q[31:23];
            next_q[21] = q[22] ^ feedback;
            next_q[20:2] = q[21:3];
            next_q[1] = q[2] ^ feedback;
            next_q[0] = q[1] ^ feedback;
            
            q <= next_q;
        end
    end
endmodule
