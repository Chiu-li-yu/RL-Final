module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output logic [511:0] q
);

    logic [511:0] next_q;
    integer i;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Rule 90: next_state = left XOR right
            // Boundary conditions: q[-1] = 0, q[512] = 0
            
            if (i == 0)
                next_q[i] = 1'b0 ^ q[1];
            else if (i == 511)
                next_q[i] = q[510] ^ 1'b0;
            else
                next_q[i] = q[i-1] ^ q[i+1];
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
