module TopModule (
    input logic clock,
    input logic a,
    output logic p,
    output logic q
);

    logic p_reg, q_reg;

    always_ff @(posedge clock) begin
        p_reg <= a;
        q_reg <= (a & p_reg) | (~a & q_reg);
    end

    assign p = p_reg;
    assign q = q_reg;

endmodule
