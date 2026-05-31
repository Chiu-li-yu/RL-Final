module TopModule (
    input clk,
    input in,
    output out
);

    logic ff_q;

    assign out = ff_q;

    always_ff @(posedge clk) begin
        ff_q <= in ^ ff_q;
    end

endmodule
