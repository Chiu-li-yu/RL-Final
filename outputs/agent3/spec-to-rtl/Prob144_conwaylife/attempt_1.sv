module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    integer r, c, i, j;
    logic [3:0] neighbors;
    logic [255:0] next_q;

    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                neighbors = 0;
                for (i = -1; i <= 1; i = i + 1) begin
                    for (j = -1; j <= 1; j = j + 1) begin
                        if (i == 0 && j == 0) continue;
                        
                        // Toroidal coordinates
                        logic [4:0] nr, nc;
                        nr = (r + i + 16) % 16;
                        nc = (c + j + 16) % 16;
                        
                        if (q[nr * 16 + nc]) 
                            neighbors = neighbors + 1;
                    end
                end

                // Rule logic
                if (neighbors < 2 || neighbors > 3)
                    next_q[r * 16 + c] = 0;
                else if (neighbors == 3)
                    next_q[r * 16 + c] = 1;
                else
                    next_q[r * 16 + c] = q[r * 16 + c];
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