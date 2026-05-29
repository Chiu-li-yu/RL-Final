
module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

    logic [255:0] current_q;
    logic [255:0] next_q;

    function automatic logic get_cell(logic [255:0] grid, int r, int c);
        int nr = (r < 0) ? 15 : (r > 15) ? 0 : r;
        int nc = (c < 0) ? 15 : (c > 15) ? 0 : c;
        // Handle the specific wrapping for -1 and 1
        // Since we'll call this with r, c as (r-1, r, r+1) and (c-1, c, c+1)
        // we should handle the modulo manually.
        return grid[nr * 16 + nc];
    endfunction

    // Redefining the indices for clarity
    always @(*) begin
        next_q = 256'b0;
        for (int r = 0; r < 16; r = r + 1) begin
            for (int c = 0; c < 16; c = c + 1) begin
                int ru = (r == 0) ? 15 : r - 1;
                int rd = (r == 15) ? 0 : r + 1;
                int cl = (c == 0) ? 15 : c - 1;
                int cr = (c == 15) ? 0 : c + 1;

                logic [3:0] count;
                count = 0;
                count = count + current_q[ru * 16 + cl];
                count = count + current_q[ru * 16 + c];
                count = count + current_q[ru * 16 + cr];
                count = count + current_q[r * 16 + cl];
                count = count + current_q[r * 16 + cr];
                count = count + current_q[rd * 16 + cl];
                count = count + current_q[rd * 16 + c];
                count = count + current_q[rd * 16 + cr];

                if (count == 3) begin
                    next_q[r * 16 + c] = 1'b1;
                end else if (count == 2) begin
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
