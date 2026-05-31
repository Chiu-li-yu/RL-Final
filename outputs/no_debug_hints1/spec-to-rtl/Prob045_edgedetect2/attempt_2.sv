module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    logic [7:0] in_prev;
    logic [7:0] anyedge_reg;

    always_ff @(posedge clk) begin
        in_prev <= in;
        anyedge_reg <= (in ^ in_prev);
    end

    assign anyedge = anyedge_reg;
endmodule
