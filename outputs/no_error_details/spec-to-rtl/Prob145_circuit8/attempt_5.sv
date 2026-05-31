module TopModule(
    input clock,
    input a,
    output p,
    output q
);
    logic p_i, q_i;

    always @(*) begin
        if (clock) begin
            p_i = a;
            q_i = q_i;
        end else begin
            p_i = p_i;
            q_i = (a | p_i);
        end
    end

    assign p = p_i;
    assign q = q_i;

endmodule