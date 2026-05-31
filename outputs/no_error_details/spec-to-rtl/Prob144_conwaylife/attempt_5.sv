module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [15:0][15:0] grid;
    logic [15:0][15:0] next_grid;
    integer r, c, i;

    // q[15:0] is row 0, q[31:16] is row 1...
    // Therefore, bit (row * 16 + col)
    always @(*) begin
        for (r = 0; r < 16; r = r + 1)
            for (c = 0; c < 16; c = c + 1)
                grid[r][c] = q[r*16 + c];
    end

    // Neighbors logic
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                integer n;
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
            for (r = 0; r < 16; r = r + 1)
                for (c = 0; c < 16; c = c + 1)
                    q[r*16 + c] <= next_grid[r][c];
        end
    end
endmodule
