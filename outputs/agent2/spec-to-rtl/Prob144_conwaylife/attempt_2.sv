module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    reg [255:0] next_q;
    integer i;
    
    // We need to unroll the neighbour summation to make it synthesis-friendly
    // Each index i = 16*r + c. r = i/16, c = i%16.
    
    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            begin
                integer r, c;
                integer count;
                integer dr, dc;
                integer nr, nc;
                
                r = i / 16;
                c = i % 16;
                count = 0;
                
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = (r + dr + 16) % 16;
                            nc = (c + dc + 16) % 16;
                            count = count + q[nr * 16 + nc];
                        end
                    end
                end
                
                if (count < 2 || count > 3)
                    next_q[i] = 0;
                else if (count == 3)
                    next_q[i] = 1;
                else
                    next_q[i] = q[i];
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
