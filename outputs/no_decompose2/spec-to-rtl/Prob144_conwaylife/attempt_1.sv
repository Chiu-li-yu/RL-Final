module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] next_q;
    integer r, c, i, j;
    logic [3:0] neighbors;
    logic [3:0] neighbor_count;

    always_ff @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                neighbor_count = 0;
                for (i = -1; i <= 1; i = i + 1) begin
                    for (j = -1; j <= 1; j = j + 1) begin
                        if (i != 0 || j != 0) begin
                            // Handle toroidal wrapping
                            int nr = (r + i + 16) % 16;
                            int nc = (c + j + 16) % 16;
                            neighbor_count = neighbor_count + q[nr * 16 + nc];
                        end
                    end
                end

                // Game of Life rules
                if (neighbor_count < 2 || neighbor_count > 3)
                    next_q[r * 16 + c] = 0;
                else if (neighbor_count == 3)
                    next_q[r * 16 + c] = 1;
                else
                    next_q[r * 16 + c] = q[r * 16 + c];
            end
        end
    end

endmodule
