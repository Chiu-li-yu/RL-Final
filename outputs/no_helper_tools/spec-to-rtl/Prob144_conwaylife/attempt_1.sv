module TopModule (
    input logic clk,
    input logic load,
    input logic [255:0] data,
    output logic [255:0] q
);

    logic [255:0] next_q;

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    // Combinational Logic for Game of Life
    always @(*) begin
        for (int i = 0; i < 16; i = i + 1) begin
            for (int j = 0; j < 16; j = j + 1) begin
                int r, c;
                int neighbors;
                neighbors = 0;

                for (r = -1; r <= 1; r = r + 1) begin
                    for (c = -1; c <= 1; c = c + 1) begin
                        if (!(r == 0 && c == 0)) begin
                            int nr = (i + r + 16) % 16;
                            int nc = (j + c + 16) % 16;
                            if (q[nr * 16 + nc]) neighbors = neighbors + 1;
                        end
                    end
                end

                if (neighbors < 2 || neighbors > 3) begin
                    next_q[i * 16 + j] = 1'b0;
                end else if (neighbors == 3) begin
                    next_q[i * 16 + j] = 1'b1;
                end else begin
                    next_q[i * 16 + j] = q[i * 16 + j];
                end
            end
        end
    end

endmodule
