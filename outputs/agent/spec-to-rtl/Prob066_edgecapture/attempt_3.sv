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
            prev_in <= in; // 重置時更新 prev_in 為當前輸入，避免 reset 後立即誤觸
        end else begin
            // 偵測從 1 到 0 的下降緣
            for (int i = 0; i < 32; i++) begin
                if (prev_in[i] == 1'b1 && in[i] == 1'b0) begin
                    out[i] <= 1'b1;
                end
            end
            prev_in <= in;
        end
    end

endmodule
