module TopModule (
    input clock,
    input a,
    output p,
    output q
);
    reg p_reg;
    reg q_reg;

    assign p = p_reg;
    assign q = q_reg;

    always @(posedge clock) begin
        p_reg <= a | q_reg;
        q_reg <= a & p_reg;
    end
endmodule