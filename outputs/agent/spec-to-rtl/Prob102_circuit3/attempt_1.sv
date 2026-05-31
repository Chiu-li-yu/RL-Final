module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // 從真值表分析:
    // q = 1 when (b=1 and (c=1 or d=1)) OR (a=1 and (c=1 or d=1))
    // q = (a | b) & (c | d)
    
    assign q = (a | b) & (c | d);

endmodule