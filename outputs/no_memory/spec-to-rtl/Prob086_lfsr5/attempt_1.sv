module TopModule (
    input clk,
    input reset,
    output logic [4:0] q
);

    logic [4:0] next_q;

    always @(*) begin
        // Galois LFSR shift-right:
        // Taps at bit positions 5 and 3 (0-indexed: index 4 and index 2)
        // Polynomial: x^5 + x^3 + 1
        // next_q[4] = q[0]
        // next_q[3] = q[4]
        // next_q[2] = q[3] ^ q[0]
        // next_q[1] = q[2]
        // next_q[0] = q[1]
        
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