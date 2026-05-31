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
        for (int row = 0; row < 16; row++) begin
            for (int col = 0; col < 16; col++) begin
                int neighbors;
                neighbors = 0;
                
                // Check all 8 neighbors using modulo arithmetic for toroid wrapping
                for (int r = -1; r <= 1; r++) begin
                    for (int c = -1; c <= 1; c++) begin
                        if (!(r == 0 && c == 0)) begin
                            int nr = (row + r + 16) % 16;
                            int nc = (col + c + 16) % 16;
                            if (q[nr * 16 + nc]) 
                                neighbors++;
                        end
                    end
                end

                // Game rules
                if (neighbors == 3)
                    q_next[row * 16 + col] = 1'b1;
                else if (neighbors == 2)
                    q_next[row * 16 + col] = q[row * 16 + col];
                else
                    q_next[row * 16 + col] = 1'b0;
            end
        end
    end

endmodule
