module TopModule (
    input logic clk,
    input logic reset,
    input logic [31:0] in,
    output logic [31:0] out
);

    logic [31:0] prev_in;

    always_ff @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            // 偵測從 1 到 0 的下降緣：prev_in[i] == 1 且 in[i] == 0
            // 捕捉機制：out[i] 若已經是 1 則保持 1，若偵測到下降緣也設為 1
            for (int i = 0; i < 32; i++) begin
                if (prev_in[i] == 1'b1 && in[i] == 1'b0) begin
                    out[i] <= 1'b1;
                end
                // else 保持當前 out[i] 值，不需要顯式寫出
            end
            prev_in <= in;
        end
    end

endmodule
