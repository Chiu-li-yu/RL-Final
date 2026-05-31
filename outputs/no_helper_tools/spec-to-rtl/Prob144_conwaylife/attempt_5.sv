module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] q_next;

    always_ff @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= q_next;
    end

    always_comb begin
        for (int i = 0; i < 256; i++) begin
            int r, c, row, col, neighbors;
            row = i / 16;
            col = i % 16;
            neighbors = 0;
            for (r = -1; r <= 1; r++) begin
                for (c = -1; c <= 1; c++) begin
                    if (!(r == 0 && c == 0)) begin
                        int nr = (row + r + 16) % 16;
                        int nc = (col + c + 16) % 16;
                        if (q[nr * 16 + nc]) neighbors++;
                    end
                end
            end
            if (neighbors == 3)
                q_next[i] = 1'b1;
            else if (neighbors == 2)
                q_next[i] = q[i];
            else
                q_next[i] = 1'b0;
        end
    end

endmodule
