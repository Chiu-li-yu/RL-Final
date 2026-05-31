module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);
    logic [255:0] next_q;

    // Direct neighbor calculation on flattened q
    integer r, c, nr, nc, neighbors;
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                neighbors = 0;
                for (nr = r - 1; nr <= r + 1; nr = nr + 1) begin
                    for (nc = c - 1; nc <= c + 1; nc = nc + 1) begin
                        if (!(nr == r && nc == c)) begin
                            neighbors = neighbors + q[((nr + 16) % 16) * 16 + ((nc + 16) % 16)];
                        end
                    end
                end

                if (neighbors == 3)
                    next_q[r * 16 + c] = 1'b1;
                else if (neighbors == 2)
                    next_q[r * 16 + c] = q[r * 16 + c];
                else
                    next_q[r * 16 + c] = 1'b0;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end
endmodule
