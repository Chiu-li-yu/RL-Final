module TopModule (
    input clk,
    input in,
    output out
);
    logic q;

    assign out = q;

    always_ff @(posedge clk) begin
        q <= in ^ q;
    end
endmodule
