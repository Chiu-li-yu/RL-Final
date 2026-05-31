module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] q_next;

    always_ff @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= q_next;
    end

    always_comb begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int count = 0;
                for (int r = -1; r <= 1; r++) begin
                    for (int c = -1; c <= 1; c++) begin
                        if (!(r == 0 && c == 0)) begin
                            int nr = (i + r + 16) % 16;
                            int nc = (j + c + 16) % 16;
                            if (q[nr * 16 + nc]) count++;
                        end
                    end
                end
                if (count == 3)
                    q_next[i * 16 + j] = 1'b1;
                else if (count == 2)
                    q_next[i * 16 + j] = q[i * 16 + j];
                else
                    q_next[i * 16 + j] = 1'b0;
            end
        end
    end

endmodule
