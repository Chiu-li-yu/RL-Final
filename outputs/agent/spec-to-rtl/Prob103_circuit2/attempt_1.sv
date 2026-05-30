module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    // 使用 XOR 閘的邏輯分析：
    // q = ~(a ^ b ^ c ^ d)
    // 檢查真值表：
    // 0000 -> 1 (0 ^ 0 ^ 0 ^ 0 = 0, 取反 = 1) - OK
    // 0001 -> 0 (0 ^ 0 ^ 0 ^ 1 = 1, 取反 = 0) - OK
    // 0011 -> 1 (0 ^ 0 ^ 1 ^ 1 = 0, 取反 = 1) - OK
    // 0110 -> 1 (0 ^ 1 ^ 1 ^ 0 = 0, 取反 = 1) - OK
    // 1111 -> 1 (1 ^ 1 ^ 1 ^ 1 = 0, 取反 = 1) - OK
    
    assign q = ~(a ^ b ^ c ^ d);
endmodule