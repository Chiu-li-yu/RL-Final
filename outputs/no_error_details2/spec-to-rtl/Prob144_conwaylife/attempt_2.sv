module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;

    // Use pure combinatorial logic to calculate next_q without procedural loops
    // Since 16x16 is fixed, we can write a function or just a generate block 
    // to map neighbors directly.

    function [3:0] count_neighbors;
        input [15:0] r;
        input [15:0] c;
        input [255:0] grid;
        begin
            count_neighbors = 
                grid[((r-1+16)%16)*16 + ((c-1+16)%16)] +
                grid[((r-1+16)%16)*16 + c] +
                grid[((r-1+16)%16)*16 + ((c+1)%16)] +
                grid[r*16 + ((c-1+16)%16)] +
                grid[r*16 + ((c+1)%16)] +
                grid[((r+1)%16)*16 + ((c-1+16)%16)] +
                grid[((r+1)%16)*16 + c] +
                grid[((r+1)%16)*16 + ((c+1)%16)];
        end
    endfunction

    integer r, c;
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                case (count_neighbors(r, c, q))
                    2: next_q[r*16 + c] = q[r*16 + c];
                    3: next_q[r*16 + c] = 1'b1;
                    default: next_q[r*16 + c] = 1'b0;
                endcase
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