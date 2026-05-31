module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    logic q_reg;
    logic d_in;

    always @(*) begin
        d_in = L ? r_in : q_in;
    end

    always @(posedge clk) begin
        q_reg <= d_in;
    end

    assign Q = q_reg;
endmodule
