module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output logic [511:0] q
);

    logic [511:0] next_q;
    integer i;

    always_ff @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Left neighbor (i+1), Right neighbor (i-1)
            // Boundaries are 0
            logic left, right;
            left = (i == 511) ? 1'b0 : q[i+1];
            right = (i == 0) ? 1'b0 : q[i-1];
            next_q[i] = left ^ right;
        end
    end

endmodule