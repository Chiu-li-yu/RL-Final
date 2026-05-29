
module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

    logic [15:0] current_grid [0:15];
    logic [15:0] next_grid [0:15];

    always @(*) begin
        for (int r = 0; r < 16; r = r + 1) begin
            for (int c = 0; c < 16; c = c + 1) begin
                // Wrap-around indices
                int ru = (r == 0) ? 15 : r - 1;
                int rd = (r == 15) ? 0 : r + 1;
                int cl = (c == 0) ? 15 : c - 1;
                int cr = (c == 15) ? 0 : c + 1;

                // Count neighbors
                logic [3:0] count;
                count = 4'd0;
                count = count + current_grid[ru][cl];
                count = count + current_grid[ru][c];
                count = count + current_grid[ru][cr];
                count = count + current_grid[r][cl];
                count = count + current_grid[r][cr];
                count = count + current_grid[rd][cl];
                count = count + current_grid[rd][c];
                count = count + current_grid[rd][cr];

                // Game of Life rules
                if (count == 3) begin
                    next_grid[r][c] = 1'b1;
                end else if (count == 2) begin
                    next_grid[r][c] = current_grid[r][c];
                end else begin
                    next_grid[r][c] = 1'b0;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            for (int r = 0; r < 16; r = r + 1) begin
                current_grid[r] <= data[(r * 16) +: 16];
            end
        end else begin
            for (int r = 0; r < 16; r = r + 1) begin
                current_grid[r] <= next_grid[r];
            end
        end
    end

    // Flatten the grid back to q
    logic [255:0] q_flat;
    always @(*) begin
        for (int r = 0; r < 16; r = r + 1) begin
            q_flat[(r * 16) +: 16] = current_grid[r];
        end
    end
    assign q = q_flat;

endmodule
