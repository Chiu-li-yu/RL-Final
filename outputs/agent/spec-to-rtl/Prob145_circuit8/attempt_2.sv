module TopModule (
    input clock,
    input a,
    output p,
    output q
);

    // 從波形來看：
    // p 似乎是 clock == 1 時的 a
    // q 似乎是跟著 p 的某種延遲，或者在特定時鐘緣觸發
    
    // 重新觀察：
    // 90ns, clock=1, a=1, p=1, q=0
    // 100ns, clock=1, a=1, p=1, q=0
    // 115ns, clock=0, a=0, p=1, q=1
    // 這看起來 p 是同步於 clock=1 的 a
    // q 是在 clock=0 的時候去採樣 p 的狀態
    
    logic p_int, q_int;
    assign p = p_int;
    assign q = q_int;

    always @(*) begin
        if (clock)
            p_int = a;
        else
            p_int = p_int; // keep
    end

    always @(negedge clock) begin
        q_int <= p_int;
    end

endmodule