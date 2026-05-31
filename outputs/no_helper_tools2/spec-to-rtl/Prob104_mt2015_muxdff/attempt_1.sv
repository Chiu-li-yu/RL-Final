module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    logic q_reg;
    logic d_next;

    assign Q = q_reg;

    always @(*) begin
        if (L) begin
            d_next = r_in;
        end else begin
            d_next = q_in;
        end
    end

    always @(posedge clk) begin
        q_reg <= d_next;
    end
endmodule
