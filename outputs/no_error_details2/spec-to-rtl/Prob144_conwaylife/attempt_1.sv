module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    integer r, c, i, j;
    integer neighbors;
    reg [255:0] next_q;

    always @(*) begin
        next_q = q;
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                neighbors = 0;
                // Check 8 neighbors with wrap-around
                neighbors = neighbors + q[((r-1+16)%16)*16 + ((c-1+16)%16)];
                neighbors = neighbors + q[((r-1+16)%16)*16 + c];
                neighbors = neighbors + q[((r-1+16)%16)*16 + ((c+1)%16)];
                neighbors = neighbors + q[r*16 + ((c-1+16)%16)];
                neighbors = neighbors + q[r*16 + ((c+1)%16)];
                neighbors = neighbors + q[((r+1)%16)*16 + ((c-1+16)%16)];
                neighbors = neighbors + q[((r+1)%16)*16 + c];
                neighbors = neighbors + q[((r+1)%16)*16 + ((c+1)%16)];

                if (neighbors < 2 || neighbors > 3)
                    next_q[r*16 + c] = 1'b0;
                else if (neighbors == 3)
                    next_q[r*16 + c] = 1'b1;
                else
                    next_q[r*16 + c] = q[r*16 + c];
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