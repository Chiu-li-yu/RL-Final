module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    logic [255:0] next_q;

    // 鄰居計算邏輯
    function [3:0] count_neighbors(input [3:0] r, input [3:0] c, input [255:0] current_q);
        logic [3:0] count;
        integer dr, dc;
        logic [3:0] nr, nc;
        begin
            count = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (dr == 0 && dc == 0) continue;
                    
                    // Toroidal wrap-around
                    nr = (r + dr) % 16;
                    nc = (c + dc) % 16;
                    
                    count = count + current_q[nr * 16 + nc];
                end
            end
            count_neighbors = count;
        end
    endfunction

    // 下一狀態邏輯
    always @(*) begin
        for (int i = 0; i < 256; i = i + 1) begin
            logic [3:0] r, c;
            logic [3:0] neighbors;
            r = i / 16;
            c = i % 16;
            neighbors = count_neighbors(r, c, q);
            
            case (neighbors)
                2: next_q[i] = q[i];
                3: next_q[i] = 1'b1;
                default: next_q[i] = 1'b0;
            endcase
        end
    end

    // 暫存器更新
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule