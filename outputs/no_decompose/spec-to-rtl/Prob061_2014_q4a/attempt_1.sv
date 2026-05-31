module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output logic Q
);

    logic q_reg;

    always_ff @(posedge clk) begin
        if (L) begin
            q_reg <= R;
        end else if (E) begin
            q_reg <= w;
        end
    end

    assign Q = q_reg;

endmodule
