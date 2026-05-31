module TopModule(
    input clk,
    input reset,
    output logic [31:0] q
);

    // Galois LFSR shift right:
    // next_q[31] = q[0]
    // for i from 30 down to 0:
    //   if (i+1 is a tap) next_q[i] = q[i+1] ^ q[0]
    //   else next_q[i] = q[i+1]
    
    // Taps at 32, 22, 2, 1
    // Indices: 31, 21, 1, 0
    
    logic [31:0] next_q;
    
    always_comb begin
        next_q[31] = q[0]; // Tap at 32
        for (int i = 30; i >= 0; i = i - 1) begin
            if (i == 21 || i == 1 || i == 0) // Taps at 22, 2, 1 (indices 21, 1, 0)
                next_q[i] = q[i+1] ^ q[0];
            else
                next_q[i] = q[i+1];
        end
    end
    
    always_ff @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule
