module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    integer r, c, i;
    integer n_r, n_c;
    integer count;
    reg [255:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            r = i / 16;
            c = i % 16;
            count = 0;
            
            // Sum 8 neighbours
            for (n_r = r - 1; n_r <= r + 1; n_r = n_r + 1) begin
                for (n_c = c - 1; n_c <= c + 1; n_c = n_c + 1) begin
                    if (!(n_r == r && n_c == c)) begin
                        // Apply modulo 16 and add to count
                        count = count + q[((n_r + 16) % 16) * 16 + ((n_c + 16) % 16)];
                    end
                end
            end

            // Game of Life rules
            if (count < 2 || count > 3)
                next_q[i] = 0;
            else if (count == 3)
                next_q[i] = 1;
            else
                next_q[i] = q[i];
        end
    end
endmodule
