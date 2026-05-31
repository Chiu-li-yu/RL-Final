module TopModule(
    input clock,
    input a,
    output p,
    output q
);

    logic p_reg, q_reg;

    // 依據觀察到的波形：
    // clock=1 時，p = a
    // clock=0 時，q = p_at_rising_edge 或類似邏輯
    // 讓我們嘗試用一個簡單的時序電路：
    
    always_ff @(posedge clock) begin
        p_reg <= a;
    end
    
    always_ff @(negedge clock) begin
        q_reg <= p_reg;
    end
    
    assign p = (clock) ? a : p_reg;
    assign q = q_reg;

endmodule
