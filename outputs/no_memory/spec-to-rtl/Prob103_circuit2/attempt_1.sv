module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // 整理真值表:
    // a b c d | q
    // 0 0 0 0 | 1
    // 0 0 0 1 | 0
    // 0 0 1 0 | 0
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 1
    // 0 1 1 0 | 1
    // 0 1 1 1 | 0
    // 1 0 0 0 | 0
    // 1 0 0 1 | 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 0
    // 1 1 0 0 | 1
    // 1 1 0 1 | 0
    // 1 1 1 0 | 0
    // 1 1 1 1 | 1

    // 這是一個 XOR 的階層關係:
    // q = ~(a ^ b ^ c ^ d)
    
    assign q = !(a ^ b ^ c ^ d);

endmodule