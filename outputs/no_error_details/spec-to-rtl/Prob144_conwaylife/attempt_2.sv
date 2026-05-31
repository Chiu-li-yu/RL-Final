module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [15:0][15:0] grid;
    logic [15:0][15:0] next_grid;
    integer r, c, i;

    // 將 q 映射為 16x16 的 grid
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            grid[i] = q[i*16 +: 16];
        end
    end

    // 計算每個格子的下一個狀態
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                integer neighbors;
                neighbors = grid[(r-1+16)%16][(c-1+16)%16] +
                            grid[(r-1+16)%16][c] +
                            grid[(r-1+16)%16][(c+1)%16] +
                            grid[r][(c-1+16)%16] +
                            grid[r][(c+1)%16] +
                            grid[(r+1)%16][(c-1+16)%16] +
                            grid[(r+1)%16][c] +
                            grid[(r+1)%16][(c+1)%16];

                if (neighbors < 2 || neighbors > 3)
                    next_grid[r][c] = 0;
                else if (neighbors == 3)
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
