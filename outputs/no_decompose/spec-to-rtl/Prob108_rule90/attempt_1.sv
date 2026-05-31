module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output logic [511:0] q
);

    logic [511:0] next_q;

    always_ff @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        // Rule 90: Center' = Left XOR Right
        // Boundaries are 0
        // q[511]: Left is 0, Right is q[510]
        next_q[511] = 1'b0 ^ q[510];
        
        // q[i] for 510 to 1
        for (int i = 510; i >= 1; i = i - 1) begin
            next_q[i] = q[i+1] ^ q[i-1];
        end
        
        // q[0]: Left is q[1], Right is 0
        next_q[0] = q[1] ^ 1'b0;
    end

endmodule
