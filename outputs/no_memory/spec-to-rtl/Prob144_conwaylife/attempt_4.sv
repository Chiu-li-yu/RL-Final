module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] next_q;

    // Helper function to get neighbor state with wrap-around
    function logic get_cell(logic [255:0] grid, int r, int c);
        int nr, nc;
        nr = (r + 16) % 16;
        nc = (c + 16) % 16;
        return grid[nr * 16 + nc];
    endfunction

    always @(*) begin
        for (int r = 0; r < 16; r = r + 1) begin
            for (int c = 0; c < 16; c = c + 1) begin
                int neighbors = 0;
                // Sum neighbors
                neighbors = get_cell(q, r-1, c-1) + get_cell(q, r-1, c) + get_cell(q, r-1, c+1) +
                            get_cell(q, r,   c-1)                     + get_cell(q, r,   c+1) +
                            get_cell(q, r+1, c-1) + get_cell(q, r+1, c) + get_cell(q, r+1, c+1);
                
                // Rule application
                if (neighbors == 2)
                    next_q[r * 16 + c] = q[r * 16 + c];
                else if (neighbors == 3)
                    next_q[r * 16 + c] = 1'b1;
                else
                    next_q[r * 16 + c] = 1'b0;
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
