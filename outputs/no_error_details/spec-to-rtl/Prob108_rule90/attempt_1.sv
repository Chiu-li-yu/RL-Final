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

    always_comb begin
        for (i = 0; i < 512; i = i + 1) begin
            // Rule 90: XOR of left and right neighbors
            // Boundary condition: q[-1] and q[512] are 0
            logic left, right;
            
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

endmodule