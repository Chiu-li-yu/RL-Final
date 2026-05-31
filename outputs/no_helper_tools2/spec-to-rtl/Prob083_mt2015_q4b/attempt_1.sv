module TopModule (
    input x,
    input y,
    output z
);
    // 根據 waveform 分析真值表：
    // x y | z
    // 0 0 | 1
    // 1 0 | 0
    // 0 1 | 0
    // 1 1 | 1
    // 這是 XNOR 閘 (x == y)
    
    assign z = ~(x ^ y);
endmodule
