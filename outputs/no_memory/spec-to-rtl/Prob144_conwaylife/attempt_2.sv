module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    integer r, c, i, j;
    logic [255:0] next_q;
    logic [3:0] neighbors;
    logic [15:0][15:0] grid;
    logic [15:0][15:0] next_grid;

    always @(*) begin
        // Map 1D to 2D
        for (i = 0; i < 16; i = i + 1) begin
            grid[i] = q[i*16 +: 16];
        end

        // Calculate next state
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                neighbors = grid[(r-1)%16][(c-1)%16] + grid[(r-1)%16][c] + grid[(r-1)%16][(c+1)%16] +
                            grid[r][(c-1)%16]                     + grid[r][(c+1)%16] +
                            grid[(r+1)%16][(c-1)%16] + grid[(r+1)%16][c] + grid[(r+1)%16][(c+1)%16];
                
                if (neighbors == 3)
                    next_grid[r][c] = 1;
                else if (neighbors == 2)
                    next_grid[r][c] = grid[r][c];
                else
                    next_grid[r][c] = 0;
            end
        end

        // Map 2D back to 1D
        for (i = 0; i < 16; i = i + 1) begin
            next_q[i*16 +: 16] = next_grid[i];
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule