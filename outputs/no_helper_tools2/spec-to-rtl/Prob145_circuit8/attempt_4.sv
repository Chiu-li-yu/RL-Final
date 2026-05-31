module TopModule (
    input clock,
    input a,
    output p,
    output q
);

    logic p_reg, q_reg;
    assign p = p_reg;
    assign q = q_reg;

    always @(posedge clock or negedge clock) begin
        if (clock) begin
            p_reg <= a;
            q_reg <= p_reg;
        end else begin
            p_reg <= a;
            q_reg <= (a | p_reg);
        end
    end

endmodule