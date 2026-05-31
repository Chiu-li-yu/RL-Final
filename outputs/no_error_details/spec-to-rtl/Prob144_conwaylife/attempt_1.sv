module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] next_q;
    integer r, c, i, j;
    integer neighbors;
    logic [15:0][15:0] grid;
    logic [15:0][15:0] next_grid;

    always @(*) begin
        // 將 q 映射為 16x16 的 grid
        for (i = 0; i < 16; i = i + 1) begin
            grid[i] = q[i*16 +: 16];
        end

        // 計算每個格子的下一個狀態
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                neighbors = 0;
                // 檢查 8 個鄰居，使用環狀邊界
                neighbors = neighbors + grid[(r-1+16)%16][(c-1+16)%16];
                neighbors = neighbors + grid[(r-1+16)%16][c];
                neighbors = neighbors + grid[(r-1+16)%16][(c+1)%16];
                neighbors = neighbors + grid[r][(c-1+16)%16];
                neighbors = neighbors + grid[r][(c+1)%16];
                neighbors = neighbors + grid[(r+1)%16][(c-1+16)%16];
                neighbors = neighbors + grid[(r+1)%16][c];
                neighbors = neighbors + grid[(r+1)%16][(c+1)%16];

                // 套用規則
                if (neighbors < 2 || neighbors > 3)
                    next_grid[r][c] = 0;
                else if (neighbors == 3)
                    next_grid[r][c] = 1;
                else
                    next_grid[r][c] = grid[r][c];
            end
        end

        // 將 next_grid 轉回 256 位元
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
