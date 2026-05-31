module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] next_q;
    logic [3:0] row, col;
    logic [3:0] neighbors;
    integer i, j, ni, nj, r, c;

    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            row = i / 16;
            col = i % 16;
            neighbors = 0;
            
            // Iterate over 8 neighbors with toroidal wrap-around
            for (r = -1; r <= 1; r = r + 1) begin
                for (c = -1; c <= 1; c = c + 1) begin
                    if (!(r == 0 && c == 0)) begin
                        ni = (row + r + 16) % 16;
                        nj = (col + c + 16) % 16;
                        if (q[ni * 16 + nj]) begin
                            neighbors = neighbors + 1;
                        end
                    end
                end
            end
            
            // Apply game rules
            if (neighbors == 2) begin
                next_q[i] = q[i];
            end else if (neighbors == 3) begin
                next_q[i] = 1;
            end else begin
                next_q[i] = 0;
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule
