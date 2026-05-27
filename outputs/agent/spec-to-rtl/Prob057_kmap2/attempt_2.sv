module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // K-map re-read:
    //    cd \ ab | 00 | 01 | 11 | 10
    //    --------------------------
    //    00      | 1  | 1  | 0  | 1
    //    01      | 1  | 0  | 0  | 1
    //    11      | 0  | 1  | 1  | 1
    //    10      | 1  | 1  | 0  | 0
    
    // Rows (cd): 00, 01, 11, 10
    // Cols (ab): 00, 01, 11, 10
    
    // Minterms where out=1:
    // (a=0,b=0,c=0,d=0), (a=0,b=1,c=0,d=0), (a=1,b=0,c=0,d=0), (a=1,b=0,c=0,d=1) -> wait, let's map carefully.
    
    // Matrix indexed as [c][d][a][b]
    // 0000: 1
    // 0001: 1
    // 0011: 0
    // 0010: 1
    // 0100: 1
    // 0101: 0
    // 0111: 0
    // 0110: 1
    // 1100: 0
    // 1101: 1
    // 1111: 1
    // 1110: 1
    // 1000: 1
    // 1001: 1
    // 1011: 0
    // 1010: 0
    
    // Let's express as a single Boolean logic:
    logic out_val;
    always @(*) begin
        out_val = (~c & ~d & ~a & ~b) | (~c & ~d & ~a & b) | (~c & ~d & a & ~b) | 
                  (~c & d & ~a & ~b) | (~c & d & a & ~b) | 
                  (c & d & a & b) | (c & d & a & ~b) | (c & d & ~a & b) |
                  (c & ~d & ~a & ~b) | (c & ~d & ~a & b);
    end

    assign out = out_val;

endmodule
