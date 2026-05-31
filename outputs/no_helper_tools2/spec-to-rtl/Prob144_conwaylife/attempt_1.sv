module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);
    logic [255:0] next_q;

    integer r, c;
    integer neighbors;
    integer nr, nc;

    always_ff @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                neighbors = 0;
                // Check all 8 neighbors with toroidal wrapping
                for (nr = r - 1; nr <= r + 1; nr = nr + 1) begin
                    for (nc = c - 1; nc <= c + 1; nc = nc + 1) begin
                        if (!(nr == r && nc == c)) begin
                            neighbors = neighbors + q[(nr % 16) * 16 + (nc % 16)];
                        end
                    end
                end

                // Game of Life rules
                if (neighbors < 2 || neighbors > 3)
                    next_q[r * 16 + c] = 1'b0;
                else if (neighbors == 3)
                    next_q[r * 16 + c] = 1'b1;
                else
                    next_q[r * 16 + c] = q[r * 16 + c];
            end
        end
    end
endmodule
