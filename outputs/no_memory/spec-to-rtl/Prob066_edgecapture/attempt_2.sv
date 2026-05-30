module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    logic [31:0] in_prev;
    logic [31:0] out_reg;

    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            in_prev <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            in_prev <= in;
            out_reg <= out_reg | (~in & in_prev);
        end
    end

endmodule
