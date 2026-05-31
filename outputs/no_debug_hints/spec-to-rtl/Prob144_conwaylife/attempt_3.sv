module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] next_q;

    // Use a generate block to unroll loops, and index properly.
    // The previous error in the simulator might have been related to the
    // use of local variables inside always @(*) blocks or how they were treated.
    // Making it purely combinatorial using index arithmetic should work.

    always @(*) begin
        for (int r = 0; r < 16; r++) begin
            for (int c = 0; c < 16; c++) begin
                int neighbors = 0;
                
                // Unrolling neighbor calculation
                // (r-1, c-1), (r-1, c), (r-1, c+1)
                // (r, c-1), (r, c+1)
                // (r+1, c-1), (r+1, c), (r+1, c+1)
                
                neighbors = 
                    q[((r+15)%16)*16 + (c+15)%16] + 
                    q[((r+15)%16)*16 + (c    )%16] + 
                    q[((r+15)%16)*16 + (c+ 1)%16] + 
                    q[((r    )%16)*16 + (c+15)%16] + 
                    q[((r    )%16)*16 + (c+ 1)%16] + 
                    q[((r+ 1)%16)*16 + (c+15)%16] + 
                    q[((r+ 1)%16)*16 + (c    )%16] + 
                    q[((r+ 1)%16)*16 + (c+ 1)%16];

                if (neighbors == 3)
                    next_q[r * 16 + c] = 1;
                else if (neighbors == 2)
                    next_q[r * 16 + c] = q[r * 16 + c];
                else
                    next_q[r * 16 + c] = 0;
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end
endmodule