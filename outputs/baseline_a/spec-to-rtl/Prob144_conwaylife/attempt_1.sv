module TopModule (
    input logic clk,
    input logic load,
    input logic [255:0] data,
    output logic [255:0] q
);
    logic [255:0] next_q;

    // Helper to calculate neighbor count for cell (r, c)
    function automatic logic [3:0] count_neighbors(input logic [3:0] r, input logic [3:0] c);
        logic [3:0] n;
        n = 0;
        // Check 8 neighbors with toroidal wrapping
        n = n + q[((r - 1) % 16) * 16 + ((c - 1) % 16)];
        n = n + q[((r - 1) % 16) * 16 + c];
        n = n + q[((r - 1) % 16) * 16 + ((c + 1) % 16)];
        n = n + q[r * 16 + ((c - 1) % 16)];
        n = n + q[r * 16 + ((c + 1) % 16)];
        n = n + q[((r + 1) % 16) * 16 + ((c - 1) % 16)];
        n = n + q[((r + 1) % 16) * 16 + c];
        n = n + q[((r + 1) % 16) * 16 + ((c + 1) % 16)];
        return n;
    endfunction

    always @(*) begin
        for (int r = 0; r < 16; r++) begin
            for (int c = 0; c < 16; c++) begin
                logic [3:0] neighbors;
                neighbors = count_neighbors(r, c);
                
                if (neighbors == 2)
                    next_q[r * 16 + c] = q[r * 16 + c];
                else if (neighbors == 3)
                    next_q[r * 16 + c] = 1'b1;
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
