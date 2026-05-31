module TopModule(
    input clk,
    input reset,
    output logic [31:0] q
);
    always_ff @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            // Galois LFSR:
            // Polynomial: x^32 + x^22 + x^2 + x^1 + 1
            // Shift right:
            // next_q[31] = q[0]
            // next_q[21] = q[22] ^ q[0]
            // next_q[1]  = q[2] ^ q[0]
            // next_q[0]  = q[1] ^ q[0]
            // others     = q[i+1]
            
            logic [31:0] next_q;
            next_q[31] = q[0];
            next_q[30:22] = q[31:23];
            next_q[21] = q[22] ^ q[0];
            next_q[20:2] = q[21:3];
            next_q[1] = q[2] ^ q[0];
            next_q[0] = q[1] ^ q[0];
            
            q <= next_q;
        end
    end
endmodule