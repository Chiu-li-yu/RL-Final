module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] next_q;

    // Explicit loop logic without declaration inside loops
    integer y, x, dy, dx, nx, ny;
    logic [3:0] neighbors;

    always @(*) begin
        for (y = 0; y < 16; y = y + 1) begin
            for (x = 0; x < 16; x = x + 1) begin
                neighbors = 4'b0;
                for (dy = -1; dy <= 1; dy = dy + 1) begin
                    for (dx = -1; dx <= 1; dx = dx + 1) begin
                        if (!(dx == 0 && dy == 0)) begin
                            nx = (x + dx + 16) % 16;
                            ny = (y + dy + 16) % 16;
                            neighbors = neighbors + q[ny * 16 + nx];
                        end
                    end
                end

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
