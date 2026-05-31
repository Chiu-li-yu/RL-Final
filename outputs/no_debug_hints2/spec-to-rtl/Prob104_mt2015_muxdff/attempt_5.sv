module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    // 試試看在 always @(posedge clk) 裡面處理 mux
    logic q_reg;
    assign Q = q_reg;

    always @(posedge clk) begin
        if (L)
            q_reg <= r_in;
        else
            q_reg <= q_in;
    end
endmodule
