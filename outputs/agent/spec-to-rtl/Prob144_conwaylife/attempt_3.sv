module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [15:0][15:0] current_grid;
    logic [15:0][15:0] next_grid;

    // Map q to 2D for easier indexing
    assign current_grid[0] = q[15:0];
    assign current_grid[1] = q[31:16];
    assign current_grid[2] = q[47:32];
    assign current_grid[3] = q[63:48];
    assign current_grid[4] = q[79:64];
    assign current_grid[5] = q[95:80];
    assign current_grid[6] = q[111:96];
    assign current_grid[7] = q[127:112];
    assign current_grid[8] = q[143:128];
    assign current_grid[9] = q[159:144];
    assign current_grid[10] = q[175:160];
    assign current_grid[11] = q[191:176];
    assign current_grid[12] = q[207:192];
    assign current_grid[13] = q[223:208];
    assign current_grid[14] = q[239:224];
    assign current_grid[15] = q[255:240];

    // Compute next_grid
    integer r, c, i, j;
    logic [3:0] count;
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                count = 0;
                for (i = -1; i <= 1; i = i + 1) begin
                    for (j = -1; j <= 1; j = j + 1) begin
                        if (!(i == 0 && j == 0)) begin
                            count = count + current_grid[(r + i + 16) % 16][(c + j + 16) % 16];
                        end
                    end
                end
                
                if (count == 2) next_grid[r][c] = current_grid[r][c];
                else if (count == 3) next_grid[r][c] = 1;
                else next_grid[r][c] = 0;
            end
        end
    end

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q[15:0] <= next_grid[0];
            q[31:16] <= next_grid[1];
            q[47:32] <= next_grid[2];
            q[63:48] <= next_grid[3];
            q[79:64] <= next_grid[4];
            q[95:80] <= next_grid[5];
            q[111:96] <= next_grid[6];
            q[127:112] <= next_grid[7];
            q[143:128] <= next_grid[8];
            q[159:144] <= next_grid[9];
            q[175:160] <= next_grid[10];
            q[191:176] <= next_grid[11];
            q[207:192] <= next_grid[12];
            q[223:208] <= next_grid[13];
            q[239:224] <= next_grid[14];
            q[255:240] <= next_grid[15];
        end
    end

endmodule
