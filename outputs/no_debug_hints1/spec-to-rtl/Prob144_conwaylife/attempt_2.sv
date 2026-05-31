module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] next_q;

    // Use a generate block or iterative approach to compute next state
    // Since we need to compute this purely in combinatorial logic
    
    always @(*) begin
        for (int r = 0; r < 16; r = r + 1) begin
            for (int c = 0; c < 16; c = c + 1) begin
                int neighbors = 0;
                for (int i = -1; i <= 1; i = i + 1) begin
                    for (int j = -1; j <= 1; j = j + 1) begin
                        if (!(i == 0 && j == 0)) begin
                            int ni = (r + i + 16) % 16;
                            int nj = (c + j + 16) % 16;
                            if (q[ni * 16 + nj]) neighbors = neighbors + 1;
                        end
                    end
                end
                
                if (neighbors == 3)
                    next_q[r * 16 + c] = 1;
                else if (neighbors == 2)
                    next_q[r * 16 + c] = q[r * 16 + c];
                else
                    next_q[r * 16 + c] = 0;
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