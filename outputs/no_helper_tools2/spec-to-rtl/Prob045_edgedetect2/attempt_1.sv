module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    logic [7:0] in_d;

    always @(posedge clk) begin
        in_d <= in;
    end

    always @(*) begin
        // anyedge will be high if the current bit is different from the previous bit
        // The previous bit is stored in in_d
    end

    assign anyedge = in ^ in_d;

endmodule