module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Karnaugh Map analysis:
    // abc | out
    // 000 | 0
    // 001 | 1
    // 010 | 1
    // 011 | 1
    // 100 | 1
    // 101 | 1
    // 110 | 1
    // 111 | 1
    
    // The output is 0 only when a=0, b=0, c=0.
    // Therefore, out = !(~a & ~b & ~c) = a | b | c
    
    always @(*) begin
        out = a | b | c;
    end
endmodule
