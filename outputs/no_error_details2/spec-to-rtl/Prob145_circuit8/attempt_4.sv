module TopModule(
    input clock,
    input a,
    output p,
    output q
);
    logic p_reg, q_reg;

    // 分析：
    // p 隨 a 變化但受 clock 控制
    // 觀測點 (a, p, q)
    // 85ns (1,0,0,0) -> 90ns (1,1,1,0) : a 從 0 變 1, p 從 0 變 1, q 仍為 0
    // 140ns (0,0,1,1) -> 145ns (1,0,0,1) : a 從 0 變 0, p 從 1 變 0, q 仍為 1
    // 這看起來像是：
    // p = a & clock;
    // q = p_reg (previous state of p_reg)
    
    always_ff @(posedge clock or negedge clock) begin
        if (clock) begin
            p_reg <= a;
        end else begin
            q_reg <= p_reg;
        end
    end

    assign p = (clock) ? a : p_reg;
    assign q = (clock) ? q_reg : q_reg; // 或者其他邏輯

endmodule
