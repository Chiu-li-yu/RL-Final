module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output logic [511:0] q
);

    logic [511:0] next_q;
    integer i;

    always_ff @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Rule 90: Center' = Left XOR Right
            // Boundaries are 0
            if (i == 0) begin
                next_q[i] = 1'b0 ^ q[1];
            end else if (i == 511) begin
                next_q[i] = q[510] ^ 1'b0;
            end else begin
                next_q[i] = q[i-1] ^ q[i+1];
            end
        end
    end

endmodule
