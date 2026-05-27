module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);
    logic [7:0] prev_in;

    always_ff @(posedge clk) begin
        prev_in <= in;
    end

    // Positive edge is detected if previous was 0 and current is 1
    assign pedge = (~prev_in) & in;

endmodule
