module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic q
);

always @(*) begin
    // 分析 truth table:
    // 當 (b or a) 為真，且 (c or d) 為真時，q 為 1
    // 檢查表格：
    // b=1, a=0: (b|a)=1. c=0,d=1 -> q=1. c=1,d=0 -> q=1. c=1,d=1 -> q=1. (Correct)
    // a=1, b=0: (b|a)=1. c=0,d=1 -> q=1. c=1,d=0 -> q=1. c=1,d=1 -> q=1. (Correct)
    // b=1, a=1: (b|a)=1. c=0,d=1 -> q=1. c=1,d=0 -> q=1. c=1,d=1 -> q=1. (Correct)
    // 其他情況 q=0
    q = (a | b) & (c | d);
end

endmodule
