module TopModule(
    input clock,
    input a,
    output p,
    output q
);
    logic p_reg, q_reg;

    always @(*) begin
        if (clock) begin
            p_reg = a;
            q_reg = q_reg; // hold
        end else begin
            p_reg = p_reg; // hold
            q_reg = a;
        end
    end

    assign p = p_reg;
    assign q = q_reg;

endmodule