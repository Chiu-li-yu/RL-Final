module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] next_q;

    // Use generate blocks to unroll loops, which is safer for synthesis.
    generate
        genvar r, c;
        for (r = 0; r < 16; r = r + 1) begin : row
            for (c = 0; c < 16; c = c + 1) begin : col
                // Since verilog generate blocks don't allow easy local variables 
                // for the sum, we write the logic out or use an assign.
                // Using assign to calculate the neighbor count for each cell.
                wire [3:0] neighbors;
                assign neighbors = 
                    q[((r+15)%16)*16 + (c+15)%16] + 
                    q[((r+15)%16)*16 + (c    )%16] + 
                    q[((r+15)%16)*16 + (c+ 1)%16] + 
                    q[((r    )%16)*16 + (c+15)%16] + 
                    q[((r    )%16)*16 + (c+ 1)%16] + 
                    q[((r+ 1)%16)*16 + (c+15)%16] + 
                    q[((r+ 1)%16)*16 + (c    )%16] + 
                    q[((r+ 1)%16)*16 + (c+ 1)%16];

                assign next_q[r * 16 + c] = (neighbors == 3) ? 1'b1 : 
                                            (neighbors == 2) ? q[r * 16 + c] : 1'b0;
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end
endmodule