module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);
    logic [7:0] prev_in;
    logic [7:0] pedge_r;

    assign pedge = pedge_r;

    always @(posedge clk) begin
        prev_in <= in;
        pedge_r <= (~prev_in) & in;
    end

endmodule
