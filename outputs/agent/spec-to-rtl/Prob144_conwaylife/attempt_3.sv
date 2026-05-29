
module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

    logic [255:0] current_q;
    logic [255:0] next_q;

    always @(*) begin
        next_q = 256'b0;
        for (int r = 0; r < 16; r = r + 1) begin
            for (int c = 0; c < 16; c = c + 1) begin
                // Wrap-around indices
                int ru = (r == 0) ? 15 : r - 1;
                int rd = (r == 15) ? 0 : r + 1;
                int cl = (c == 0) ? 15 : c - 1;
                int cr = (c == 15) ? 0 : c + 1;

                // Neighbor counting - explicitly cast to 4-bit
                logic [3:0] count;
                count = 4'd0;
                count = count + (current_q[ru * 16 + cl] ? 4'd1 : 4'd0);
                count = count + (current_q[ru * 16 + c]   ? 4'd1 : 4'd0);
                count = count + (current_q[ru * 16 + cr]   ? 4'd1 : 4'd0);
                count = count + (current_q[r * 16 + cl]    ? 4'd1 : 4'd0);
                count = count + (current_q[r * 16 + cr]    ? 4'd1 : 4'd0);
                count = count + (current_q[rd * 16 + cl]    ? 4'd1 : 4'd0);
                count = count + (current_q[rd * 16 + c]    ? 4'd1 : 4'd0);
                count = count + (current_q[rd * 16 + cr]    ? 4'd1 : 4'd0);

                // Rule implementation
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
