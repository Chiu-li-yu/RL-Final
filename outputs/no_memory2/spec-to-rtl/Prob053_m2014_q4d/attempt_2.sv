module TopModule(
    input clk,
    input in,
    output out
);

    logic ff_out;

    always @(posedge clk) begin
        ff_out <= in ^ ff_out;
    end

    assign out = ff_out;

endmodule
