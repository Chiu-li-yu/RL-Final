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
            logic left, right;
            
            // Boundary conditions: q[-1] = 0, q[512] = 0
            if (i == 0)
                left = 1'b0;
            else
                left = q[i-1];
            
            if (i == 511)
                right = 1'b0;
            else
                right = q[i+1];
            
            next_q[i] = left ^ right;
        end
    end

    always_ff @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
