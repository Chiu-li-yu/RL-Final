module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [15:0][15:0] grid;
    logic [15:0][15:0] next_grid;

    // Convert vector to 2D array
    integer i, j;
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                grid[i][j] = q[i * 16 + j];
            end
        end
    end

    // Compute next state
    integer r, c, nr, nc;
    logic [3:0] neighbors;
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                neighbors = 0;
                for (nr = -1; nr <= 1; nr = nr + 1) begin
                    for (nc = -1; nc <= 1; nc = nc + 1) begin
                        if (nr != 0 || nc != 0) begin
                            neighbors = neighbors + grid[(r + nr + 16) % 16][(c + nc + 16) % 16];
                        end
                    end
                end
                
                if (neighbors == 2) next_grid[r][c] = grid[r][c];
                else if (neighbors == 3) next_grid[r][c] = 1;
                else next_grid[r][c] = 0;
            end
        end
    end

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    q[i * 16 + j] <= next_grid[i][j];
                end
            end
        end
    end

endmodule
