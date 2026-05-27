module TopModule (
    input clk,
    input in,
    output out
);

    logic q_next;
    logic q_reg;

    assign out = q_reg;

    always @(*) begin
        q_next = in ^ q_reg;
    end

    always @(posedge clk) begin
        q_reg <= q_next;
    end

endmodule
