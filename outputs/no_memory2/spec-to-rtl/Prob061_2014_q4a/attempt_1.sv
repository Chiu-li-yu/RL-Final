module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output logic Q
);

    logic q_reg;

    assign Q = q_reg;

    always_ff @(posedge clk) begin
        if (L) begin
            q_reg <= R;
        end else if (E) begin
            q_reg <= w;
        end else begin
            q_reg <= q_reg;
        end
    end

endmodule