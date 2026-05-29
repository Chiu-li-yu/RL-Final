
module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

    logic [255:0] current_q;
    logic [255:0] next_q;

    // State update logic
    always @(*) begin
        next_q = 256'b0;
        for (int r = 0; r < 16; r = r + 1) begin
            for (int c = 0; c < 16; c = c + 1) begin
                // Neighbors wrap-around coordinates
                int r_up = (r == 0) ? 15 : r - 1;
                int r_down = (r == 15) ? 0 : r + 1;
                int c_left = (c == 0) ? 15 : c - 1;
                int c_right = (c == 15) ? 0 : c + 1;

                // Count neighbors
                logic [3:0] neighbors;
                neighbors = current_q[r_up * 16 + c_left] +
                            current_q[r_up * 16 + c]       +
                            current_q[r_up * 16 + c_right]  +
                            current_q[r * 16 + c_left]      +
                            current_q[r * 16 + c_right]     +
                            current_q[r_down * 16 + c_left] +
                            current_q[r_down * 16 + c]       +
                            current_q[r_down * 16 + c_right];

                // Game of Life rules:
                // (1) 0-1 neighbour: Cell becomes 0.
                // (2) 2 neighbours: Cell state does not change.
                // (3) 3 neighbours: Cell becomes 1.
                // (4) 4+ neighbours: Cell becomes 0.
                if (neighbors == 3) begin
                    next_q[r * 16 + c] = 1'b1;
                end else if (neighbors == 2) begin
                    next_q[r * 16 + c] = current_q[r * 16 + c];
                end else begin
                    next_q[r * 16 + c] = 1'b0;
                end
            end
        end
    end

    // Sequential logic
    always @(posedge clk) begin
        if (load) begin
            current_q <= data;
        end else begin
            current_q <= next_q;
        end
    end

    assign q = current_q;

endmodule
