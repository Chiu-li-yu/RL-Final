module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    logic [7:0] in_prev;
    logic [7:0] pedge_reg;

    always_ff @(posedge clk) begin
        in_prev <= in;
        pedge_reg <= (~in_prev) & in;
    end

    assign pedge = pedge_reg;

endmodule
