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

    // Direct translation:
    // (a=0,b=0,c=0,d=0) = 1
    // (a=0,b=0,c=0,d=1) = 1
    // (a=0,b=0,c=1,d=0) = 0
    // (a=0,b=0,c=1,d=1) = 1
    // (a=0,b=1,c=0,d=0) = 1
    // (a=0,b=1,c=0,d=1) = 0
    // (a=0,b=1,c=1,d=0) = 1
    // (a=0,b=1,c=1,d=1) = 1
    // (a=1,b=0,c=0,d=0) = 1
    // (a=1,b=0,c=0,d=1) = 1
    // (a=1,b=0,c=1,d=0) = 0
    // (a=1,b=0,c=1,d=1) = 0
    // (a=1,b=1,c=0,d=0) = 0
    // (a=1,b=1,c=0,d=1) = 0
    // (a=1,b=1,c=1,d=0) = 1
    // (a=1,b=1,c=1,d=1) = 1

    logic out_val;
    always @(*) begin
        out_val = (~a & ~b & ~c & ~d) | 
                  (~a & ~b & ~c & d) | 
                  (~a & ~b & c & d) | 
                  (~a & b & ~c & ~d) | 
                  (~a & b & c & ~d) | 
                  (~a & b & c & d) | 
                  (a & ~b & ~c & ~d) | 
                  (a & ~b & ~c & d) | 
                  (a & b & c & ~d) | 
                  (a & b & c & d);
    end
    assign out = out_val;
endmodule
