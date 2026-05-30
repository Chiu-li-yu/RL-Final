module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [15:0][15:0] grid;
    logic [15:0][15:0] next_grid;

    // Convert 256-bit to 16x16
    integer i, j;
    always_comb begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                grid[i][j] = q[i * 16 + j];
            end
        end
    end

    // Calculate next state
    always_comb begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                logic [3:0] neighbors;
                neighbors = grid[(i + 15) % 16][(j + 15) % 16] +
                            grid[(i + 15) % 16][j] +
                            grid[(i + 15) % 16][(j + 1) % 16] +
                            grid[i][(j + 15) % 16] +
                            grid[i][(j + 1) % 16] +
                            grid[(i + 1) % 16][(j + 15) % 16] +
                            grid[(i + 1) % 16][j] +
                            grid[(i + 1) % 16][(j + 1) % 16];
                
                if (neighbors < 2 || neighbors > 3)
                    next_grid[i][j] = 1'b0;
                else if (neighbors == 3)
                    next_grid[i][j] = 1'b1;
                else
                    next_grid[i][j] = grid[i][j];
            end
        end
    end

    // Update state
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    q[i * 16 + j] <= data[i * 16 + j];
                end
            end
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    q[i * 16 + j] <= next_grid[i][j];
                end
            end
        end
    end

endmodule
