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
            // 檢查每一位是否從 1 變為 0
            // 如果某一位之前是 1 且現在是 0，則該位元在 out 中變為 1 並保持
            for (int i = 0; i < 32; i++) begin
                if (prev_in[i] && !in[i]) begin
                    out[i] <= 1'b1;
                end
            end
            prev_in <= in;
        end
    end

endmodule
