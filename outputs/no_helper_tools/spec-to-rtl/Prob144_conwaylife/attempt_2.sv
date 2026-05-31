module TopModule (
    input logic clk,
    input logic load,
    input logic [255:0] data,
    output logic [255:0] q
);

    logic [255:0] q_next;

    // Sequential update
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= q_next;
    end

    // Combinational Logic for Game of Life
    always @(*) begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int neighbors;
                neighbors = 0;
                
                // Check all 8 neighbors using modulo arithmetic for toroid wrapping
                for (int r = -1; r <= 1; r++) begin
                    for (int c = -1; c <= 1; c++) begin
                        if (r != 0 || c != 0) begin
                            int nr = (i + r + 16) % 16;
                            int nc = (j + c + 16) % 16;
                            if (q[nr * 16 + nc]) 
                                neighbors++;
                        end
                    end
                end

                // Game rules
                if (neighbors < 2 || neighbors > 3)
                    q_next[i * 16 + j] = 1'b0;
                else if (neighbors == 3)
                    q_next[i * 16 + j] = 1'b1;
                else
                    q_next[i * 16 + j] = q[i * 16 + j];
            end
        end
    end

endmodule
