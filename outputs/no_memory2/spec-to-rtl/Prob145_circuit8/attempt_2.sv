module TopModule (
    input clock,
    input a,
    output p,
    output q
);
    logic p_reg, q_reg;

    assign p = p_reg;
    assign q = q_reg;

    always @(*) begin
        if (clock) begin
            p_reg = a;
        end else begin
            p_reg = p_reg;
        end
    end

    always @(*) begin
        if (!clock) begin
            q_reg = p_reg;
        end else begin
            q_reg = q_reg;
        end
    end

    initial begin
        p_reg = 0;
        q_reg = 0;
    end
endmodule