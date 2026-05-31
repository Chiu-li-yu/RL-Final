module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    logic q_reg;
    logic mux_out;

    assign Q = q_reg;

    always @(*) begin
        if (L) begin
            mux_out = r_in;
        end else begin
            mux_out = q_in;
        end
    end

    always @(posedge clk) begin
        q_reg <= mux_out;
    end
endmodule
