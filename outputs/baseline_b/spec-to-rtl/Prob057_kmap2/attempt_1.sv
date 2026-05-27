module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Karnaugh Map (ab / cd):
    //       ab
    // cd   00  01  11  10
    // 00 | 1 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 0 | 1 |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 1 | 1 | 0 | 0 |
    
    // Minimized expression:
    // Groups:
    // (a=0, b=0, c=0, d=0) + (a=0, b=1, c=0, d=0) + (a=1, b=0, c=0, d=0) -> ~c&~d&(~a | ~b)
    // (a=0, b=0, c=0, d=1) + (a=1, b=0, c=0, d=1) -> ~b&~c&d
    // (a=0, b=1, c=1, d=1) + (a=1, b=1, c=1, d=1) -> a&b&c&d | ~a&b&c&d
    // ... Actually, mapping to logic:
    // Truth table:
    // abcd | out
    // 0000 | 1
    // 0001 | 1
    // 0010 | 1
    // 0011 | 0
    // 0100 | 1
    // 0101 | 0
    // 0110 | 1
    // 0111 | 1
    // 1000 | 1
    // 1001 | 1
    // 1010 | 0
    // 1011 | 1
    // 1100 | 1
    // 1101 | 0
    // 1110 | 0
    // 1111 | 1

    logic out_val;
    always @(*) begin
        out_val = (~a & ~b & ~c & ~d) | 
                  (~a & ~b & ~c &  d) | 
                  (~a & ~b &  c & ~d) | 
                  (~a &  b & ~c & ~d) | 
                  (~a &  b &  c &  d) | 
                  ( a & ~b & ~c & ~d) | 
                  ( a & ~b & ~c &  d) | 
                  ( a & ~b &  c &  d) | 
                  ( a &  b & ~c & ~d) | 
                  ( a &  b &  c &  d);
    end
    
    assign out = out_val;

endmodule