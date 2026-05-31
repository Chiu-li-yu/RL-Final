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
            // Rule 90: next_state[i] = left_neighbor XOR right_neighbor
            // q[i-1] for i=0 is 0
            // q[i+1] for i=511 is 0
            logic left, right;
            left = (i == 0) ? 1'b0 : q[i-1];
            right = (i == 511) ? 1'b0 : q[i+1];
            next_q[i] = left ^ right;
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end
endmodule
