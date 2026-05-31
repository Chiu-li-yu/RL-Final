module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Karnaugh Map:
    //      ab
    // cd  00 01 11 10
    // 00 | 1 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 0 | 1 |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 1 | 1 | 0 | 0 |

    // Boolean expression mapping:
    // F(a,b,c,d) = Σ(0,1,3,4,5,7,10,11,12,14,15)
    // Actually, reading the K-Map:
    // (a=0,b=0,c=0,d=0) -> 1
    // (a=0,b=1,c=0,d=0) -> 1
    // (a=1,b=1,c=0,d=0) -> 0
    // (a=1,b=0,c=0,d=0) -> 1
    // (a=0,b=0,c=0,d=1) -> 1
    // ...
    
    // Using Karnaugh map simplification:
    // Minimized expression for 1s:
    // out = (~b & ~c) | (a & ~c & ~d) | (b & c & d) | (~a & c & d) | (~a & ~b & ~d)
    
    logic out_logic;
    always @(*) begin
        out_logic = (~b & ~c) | (a & ~c & ~d) | (b & c & d) | (~a & c & d) | (~a & ~b & ~d);
    end
    assign out = out_logic;
endmodule
