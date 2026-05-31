module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);
    logic [255:0] next_q;

    // Use a 2D array for easier index management
    logic [15:0] grid [15:0];
    logic [15:0] next_grid [15:0];

    // Convert flat q to 2D array
    integer r, c;
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            grid[r] = q[r*16 +: 16];
        end
    end

    // Compute next state
    integer nr, nc;
    integer neighbors;
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                neighbors = 0;
                // Toroidal neighbors
                neighbors = grid[(r-1)%16][(c-1)%16] + grid[(r-1)%16][c] + grid[(r-1)%16][(c+1)%16] +
                            grid[r][(c-1)%16] + grid[r][(c+1)%16] +
                            grid[(r+1)%16][(c-1)%16] + grid[(r+1)%16][c] + grid[(r+1)%16][(c+1)%16];
                
                if (neighbors == 3)
                    next_grid[r][c] = 1'b1;
                else if (neighbors == 2)
                    next_grid[r][c] = grid[r][c];
                else
                    next_grid[r][c] = 1'b0;
            end
        end
    end

    // Convert 2D next_grid to flat next_q
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            next_q[r*16 +: 16] = next_grid[r];
        end
    end

    // Sequential update
    always_ff @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
