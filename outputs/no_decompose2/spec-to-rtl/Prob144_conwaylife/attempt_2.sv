module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] next_q;
    integer r, c, i, j;
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
                        if (!(i == 0 && j == 0)) begin
                            // Handle toroidal wrapping correctly
                            // Using (r + i + 16) % 16 might be interpreted
                            // as signed or unsigned differently.
                            // Let's use manual wrapping.
                            int rr, cc;
                            if (r + i == -1) rr = 15;
                            else if (r + i == 16) rr = 0;
                            else rr = r + i;

                            if (c + j == -1) cc = 15;
                            else if (c + j == 16) cc = 0;
                            else cc = c + j;

                            neighbor_count = neighbor_count + q[rr * 16 + cc];
                        end
                    end
                end

                // Game of Life rules
                if (neighbor_count == 3)
                    next_q[r * 16 + c] = 1;
                else if (neighbor_count == 2)
                    next_q[r * 16 + c] = q[r * 16 + c];
                else
                    next_q[r * 16 + c] = 0;
            end
        end
    end

endmodule
