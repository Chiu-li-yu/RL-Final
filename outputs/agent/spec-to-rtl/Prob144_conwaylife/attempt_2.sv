module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [15:0][15:0] next_grid;
    integer r, c, nr, nc;
    logic [3:0] neighbors;

    // Use generate for structured logic
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                
                always @(*) begin
                    neighbors = 0;
                    for (nr = -1; nr <= 1; nr = nr + 1) begin
                        for (nc = -1; nc <= 1; nc = nc + 1) begin
                            if (!(nr == 0 && nc == 0)) begin
                                neighbors = neighbors + q[((i + nr + 16) % 16) * 16 + ((j + nc + 16) % 16)];
                            end
                        end
                    end

                    if (neighbors == 2) next_grid[i][j] = q[i * 16 + j];
                    else if (neighbors == 3) next_grid[i][j] = 1;
                    else next_grid[i][j] = 0;
                end
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (int r_idx = 0; r_idx < 16; r_idx = r_idx + 1) begin
                for (int c_idx = 0; c_idx < 16; c_idx = c_idx + 1) begin
                    q[r_idx * 16 + c_idx] <= next_grid[r_idx][c_idx];
                end
            end
        end
    end
endmodule
