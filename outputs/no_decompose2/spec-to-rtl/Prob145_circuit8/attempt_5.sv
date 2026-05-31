module TopModule (
    input logic clock,
    input logic a,
    output logic p,
    output logic q
);
    logic p_reg;
    logic q_reg;

    always_ff @(posedge clock or negedge clock) begin
        if (clock) begin
            p_reg <= a;
        end else begin
            q_reg <= p_reg;
        end
    end

    assign p = p_reg;
    assign q = q_reg;
endmodule
