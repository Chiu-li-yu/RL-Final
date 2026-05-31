module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    logic q_reg;
    logic mux_out;

    always @(*) begin
        mux_out = L ? r_in : q_in;
    end

    always @(posedge clk) begin
        q_reg <= mux_out;
    end

    assign Q = q_reg;
endmodule
