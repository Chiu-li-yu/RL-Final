module TopModule(
    input clock,
    input a,
    output p,
    output q
);

    logic p_reg;
    logic q_reg;

    always_ff @(posedge clock) begin
        p_reg <= a;
        q_reg <= p_reg;
    end

    assign p = p_reg;
    assign q = q_reg;

endmodule