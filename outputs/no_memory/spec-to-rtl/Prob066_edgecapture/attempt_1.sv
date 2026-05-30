module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    logic [31:0] prev_in;
    logic [31:0] latch_reg;

    assign out = latch_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_in   <= 32'b0;
            latch_reg <= 32'b0;
        end else begin
            prev_in   <= in;
            latch_reg <= latch_reg | (~in & prev_in);
        end
    end

endmodule