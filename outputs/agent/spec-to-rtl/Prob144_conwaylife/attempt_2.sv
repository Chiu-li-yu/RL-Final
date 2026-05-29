
module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

    logic [255:0] current_q;
    logic [255:0] next_q;

    // Use integer for loop counters
    integer r, c;
    
    always @(*) begin
        next_q = 256'b0;
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                // Wrap-around coordinates
                integer r_up = (r == 0) ? 15 : r - 1;
                integer r_down = (r == 15) ? 0 : r + 1;
                integer c_left = (c == 0) ? 15 : c - 1;
                integer c_right = (c == 15) ? 0 : c + 1;

                // Count neighbors
                logic [3:0] neighbors;
                neighbors = 4'd0;
                neighbors = neighbors + current_q[r_up * 16 + c_left];
                neighbors = neighbors + current_q[r_up * 16 + c];
                neighbors = neighbors + current_q[r_up * 16 + c_right];
                neighbors = neighbors + current_q[r * 16 + c_left];
                neighbors = neighbors + current_q[r * 16 + c_right];
                neighbors = neighbors + current_q[r_down * 16 + c_left];
                neighbors = neighbors + current_q[r_down * 16 + c];
                neighbors = neighbors + current_q[r_down * 16 + c_right];

                // Game of Life rules
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

    always @(posedge clk) begin
        if (load) begin
            current_q <= data;
        end else begin
            current_q <= next_q;
        end
    end

    assign q = current_q;

endmodule
