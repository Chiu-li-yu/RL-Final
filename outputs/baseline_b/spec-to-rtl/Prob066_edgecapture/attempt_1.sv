module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    logic [31:0] prev_in;
    logic [31:0] detected;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            detected <= 32'b0;
        end else begin
            prev_in <= in;
            // 偵測從 1 變 0: (prev_in[i] == 1) && (in[i] == 0)
            // 只要偵測到一次，detected[i] 就保持 1
            detected <= detected | (prev_in & ~in);
        end
    end

    assign out = detected;

endmodule
