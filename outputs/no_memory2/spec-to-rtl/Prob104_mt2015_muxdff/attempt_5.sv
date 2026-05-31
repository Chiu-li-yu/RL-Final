module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    logic q_reg;

    always_ff @(posedge clk) begin
        if (L)
            q_reg <= r_in;
        else
            q_reg <= q_in;
    end

    assign Q = q_reg;
endmodule
