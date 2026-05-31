module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    logic [7:0] last_in;

    always_ff @(posedge clk) begin
        last_in <= in;
    end

    assign anyedge = in ^ last_in;

endmodule
