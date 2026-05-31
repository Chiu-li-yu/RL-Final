module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    logic [7:0] prev_in;
    logic [7:0] anyedge_reg;

    always_ff @(posedge clk) begin
        prev_in <= in;
        anyedge_reg <= in ^ prev_in;
    end

    assign anyedge = anyedge_reg;

endmodule
