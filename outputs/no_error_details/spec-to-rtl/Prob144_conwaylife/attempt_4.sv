module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [15:0][15:0] grid;
    logic [15:0][15:0] next_grid;
    integer r, c, i;

    // Grid row order clarification: q[15:0] is row 0.
    // So grid[0] should be q[15:0], grid[1] = q[31:16]
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            grid[i] = q[i*16 +: 16];
        end
    end

    // Neighbors logic
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                integer n;
                // Note: bit index 0 is (row 0, col 0)
                // Grid index: grid[row][col]
                // Row 0 is at bottom? No, usually row 0 is top.
                // Spec says: "q[15:0] is row 0, q[31:16] is row 1"
                // Let's assume standard index: grid[row][col] -> q[row*16 + col]
                n = grid[(r+15)%16][(c+15)%16] +
                    grid[(r+15)%16][c] +
                    grid[(r+15)%16][(c+1)%16] +
                    grid[r][(c+15)%16] +
                    grid[r][(c+1)%16] +
                    grid[(r+1)%16][(c+15)%16] +
                    grid[(r+1)%16][c] +
                    grid[(r+1)%16][(c+1)%16];

                if (n < 2 || n > 3)
                    next_grid[r][c] = 0;
                else if (n == 3)
                    next_grid[r][c] = 1;
                else
                    next_grid[r][c] = grid[r][c];
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else begin
            for (i = 0; i < 16; i = i + 1) begin
                q[i*16 +: 16] <= next_grid[i];
            end
        end
    end
endmodule
