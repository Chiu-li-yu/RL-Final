module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output logic [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Rule 90: next_state[i] = q[i-1] ^ q[i+1]
            // Boundaries are 0
            q[0] <= 0 ^ q[1];
            q[511] <= q[510] ^ 0;
            for (int i = 1; i < 511; i = i + 1) begin
                q[i] <= q[i-1] ^ q[i+1];
            end
        end
    end

endmodule
