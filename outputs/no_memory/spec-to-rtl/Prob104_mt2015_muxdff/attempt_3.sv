module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    logic q_reg;
    logic next_q;

    assign Q = q_reg;

    always @(*) begin
        if (L) begin
            next_q = q_in;
        end else begin
            next_q = r_in;
        end
    end

    always @(posedge clk) begin
        q_reg <= next_q;
    end

endmodule
