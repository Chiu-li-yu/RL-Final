module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [7:0] pedge
);

    logic [7:0] in_prev;
    logic [7:0] pedge_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            in_prev <= 8'b0;
            pedge_reg <= 8'b0;
        end else begin
            in_prev <= in;
            pedge_reg <= (~in_prev) & in;
        end
    end

    assign pedge = pedge_reg;

endmodule
