module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] next_q;

    // Use a function for neighbor calculation to keep always block clean and synthesizable
    function automatic [3:0] count_neighbors(input logic [255:0] grid, input integer x, input integer y);
        logic [3:0] count;
        integer dx, dy, nx, ny;
        count = 0;
        for (dy = -1; dy <= 1; dy = dy + 1) begin
            for (dx = -1; dx <= 1; dx = dx + 1) begin
                if (!(dx == 0 && dy == 0)) begin
                    nx = (x + dx + 16) % 16;
                    ny = (y + dy + 16) % 16;
                    count = count + grid[ny * 16 + nx];
                end
            end
        end
        return count;
    endfunction

    always @(*) begin
        for (integer y = 0; y < 16; y = y + 1) begin
            for (integer x = 0; x < 16; x = x + 1) begin
                logic [3:0] neighbors;
                neighbors = count_neighbors(q, x, y);
                if (neighbors < 2 || neighbors > 3)
                    next_q[y * 16 + x] = 1'b0;
                else if (neighbors == 3)
                    next_q[y * 16 + x] = 1'b1;
                else
                    next_q[y * 16 + x] = q[y * 16 + x];
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
