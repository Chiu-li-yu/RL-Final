module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Let's re-read the K-Map carefully.
    // cd / ab  00  01  11  10
    // 00      | 1 | 1 | 0 | 1 |
    // 01      | 1 | 0 | 0 | 1 |
    // 11      | 0 | 1 | 1 | 1 |
    // 10      | 1 | 1 | 0 | 0 |

    // Wait, the input is:
    // a b c d | output
    // 0 0 0 0 | 1 (00, 00)
    // 0 0 0 1 | 1 (01, 00)
    // 0 0 1 0 | 1 (10, 00)
    // 0 0 1 1 | 0 (11, 00)
    
    // 0 1 0 0 | 1 (00, 01)
    // 0 1 0 1 | 0 (01, 01)
    // 0 1 1 0 | 1 (10, 01)
    // 0 1 1 1 | 1 (11, 01)

    // 1 1 0 0 | 0 (00, 11)
    // 1 1 0 1 | 0 (01, 11)
    // 1 1 1 0 | 0 (10, 11)
    // 1 1 1 1 | 1 (11, 11)

    // 1 0 0 0 | 1 (00, 10)
    // 1 0 0 1 | 1 (01, 10)
    // 1 0 1 0 | 0 (10, 10)
    // 1 0 1 1 | 1 (11, 10)

    logic out_val;
    always @(*) begin
        // Using Karnaugh map cell coordinates
        // Row = cd, Col = ab
        // Cell(0,0)=1, Cell(1,0)=1, Cell(3,0)=0, Cell(2,0)=1
        // Cell(0,1)=1, Cell(1,1)=0, Cell(3,1)=1, Cell(2,1)=1
        // Cell(0,3)=0, Cell(1,3)=0, Cell(3,3)=1, Cell(2,3)=0
        // Cell(0,2)=1, Cell(1,2)=1, Cell(3,2)=1, Cell(2,2)=0
        
        // Let's list the ones:
        // (a=0,b=0,c=0,d=0), (a=0,b=0,c=0,d=1), (a=0,b=0,c=1,d=0)
        // (a=0,b=1,c=0,d=0), (a=0,b=1,c=1,d=0), (a=0,b=1,c=1,d=1)
        // (a=1,b=1,c=1,d=1)
        // (a=1,b=0,c=0,d=0), (a=1,b=0,c=0,d=1), (a=1,b=0,c=1,d=1)
        
        out_val = (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & ~b & c & ~d) |
                  (~a & b & ~c & ~d) | (~a & b & c & ~d) | (~a & b & c & d) |
                  (a & b & c & d) |
                  (a & ~b & ~c & ~d) | (a & ~b & ~c & d) | (a & ~b & c & d);
    end
    assign out = out_val;
endmodule
