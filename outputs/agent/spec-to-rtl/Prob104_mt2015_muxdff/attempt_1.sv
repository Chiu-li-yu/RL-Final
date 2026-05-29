module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    logic q_reg;
    logic d_in;

    assign Q = q_reg;

    always @(*) begin
        if (L) begin
            d_in = r_in;
        end else begin
            d_in = q_in;
        end
    end

    always @(posedge clk) begin
        q_reg <= d_in;
    end

endmodule
