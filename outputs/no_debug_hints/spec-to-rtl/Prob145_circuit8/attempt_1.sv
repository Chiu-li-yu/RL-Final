module TopModule(
    input clock,
    input a,
    output p,
    output q
);

    logic p_reg;
    logic q_reg;

    always @(posedge clock) begin
        if (a)
            p_reg <= 1'b1;
        else
            p_reg <= 1'b0;
    end

    always @(negedge clock) begin
        q_reg <= p_reg;
    end

    assign p = (clock == 1'b1) ? p_reg : 1'b0;
    assign q = q_reg;

endmodule