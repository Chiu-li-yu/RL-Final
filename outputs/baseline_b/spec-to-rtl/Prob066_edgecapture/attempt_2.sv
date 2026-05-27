module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    logic [31:0] prev_in;
    logic [31:0] captured;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end else begin
            prev_in <= in;
            // 偵測 1 到 0 的轉換: prev_in[i] == 1 && in[i] == 0
            // 如果偵測到，將對應的 bit 設定為 1
            captured <= captured | (prev_in & ~in);
        end
    end

    assign out = captured;

endmodule
