module TopModule (
    input clk,
    input in,
    output out
);

    logic q_reg;

    initial begin
        q_reg = 0;
    end

    always_ff @(posedge clk) begin
        q_reg <= in ^ q_reg;
    end

    assign out = q_reg;

endmodule
