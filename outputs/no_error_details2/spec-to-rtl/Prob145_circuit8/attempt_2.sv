module TopModule(
    input clock,
    input a,
    output p,
    output q
);

    logic p_out, q_out;
    
    // 從觀察 waveform 中，p 是 a 的直接輸出（在時鐘上升沿後），
    // q 則是 p 的前一個狀態的儲存（或是 a 在兩個時鐘週期前的狀態）。
    // 在 70ns, 80ns, 90ns, 100ns, 110ns, 165ns 等處觀察 a, p, q 的變化。
    
    // 重新分析：
    // clock上升沿(例如25ns, 85ns, 145ns...)
    // 觀測點：
    // time 85ns: a=0, p=0, q=0
    // time 90ns: a=1, p=1, q=0
    // time 95ns: a=0, p=0, q=0
    // time 100ns: a=1, p=1, q=0
    // time 105ns: a=0, p=0, q=0
    // time 110ns: a=1, p=1, q=0
    // time 115ns: a=0, p=1, q=1
    
    // 看起來 p = a (在 clock 上升沿採樣)
    // q = p (在 clock 下降沿採樣，或是 q 跟隨前一個 p 的值)

    logic p_d;

    always_ff @(posedge clock) begin
        p_d <= a;
    end

    always_ff @(negedge clock) begin
        q_out <= p_d;
    end

    assign p = p_d;
    assign q = q_out;

endmodule
