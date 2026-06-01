module TopModule(
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
            // Left neighbor is q[i+1], Right neighbor is q[i-1]
            // Boundaries: q[512] = 0, q[-1] = 0
            logic left, right;
            
            if (i == 511)
                left = 1'b0;
            else
                left = q[i+1];
                
            if (i == 0)
                right = 1'b0;
            else
                right = q[i-1];
            
            next_q[i] = left ^ right;
        end
    end

endmodule
