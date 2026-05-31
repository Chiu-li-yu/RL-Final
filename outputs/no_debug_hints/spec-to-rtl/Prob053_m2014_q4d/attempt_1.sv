module TopModule (
    input clk,
    input in,
    output out
);

    logic q;
    logic next_q;

    assign out = q;

    always @(posedge clk) begin
        q <= next_q;
    end

    always @(*) begin
        next_q = in ^ q;
    end

endmodule
