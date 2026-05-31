module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);
    // Karnaugh Map:
    //      ab
    // cd | 00 | 01 | 11 | 10
    // 00 | 0  | d  | 1  | 1
    // 01 | 0  | 0  | d  | d
    // 11 | 1  | 0  | 1  | 1
    // 10 | 1  | 0  | 1  | 1
    
    // Rows (cd): 00=0, 01=1, 11=3, 10=2
    // Cols (ab): 00=0, 01=1, 11=3, 10=2
    
    // Mapping:
    // (c,d,a,b)
    // 0,0,0,0 -> 0
    // 0,0,0,1 -> d -> 0
    // 0,0,1,1 -> 1
    // 0,0,1,0 -> 1
    // 0,1,0,0 -> 0
    // 0,1,0,1 -> 0
    // 0,1,1,1 -> d -> 1
    // 0,1,1,0 -> d -> 1
    // 1,1,0,0 -> 0
    // 1,1,0,1 -> 1
    // 1,1,1,1 -> 1
    // 1,1,1,0 -> 1
    // 1,0,0,0 -> 0
    // 1,0,0,1 -> 1
    // 1,0,1,1 -> 1
    // 1,0,1,0 -> 1

    always @(*) begin
        out = (a & ~c) | (a & b) | (~b & c & ~d) | (a & c);
    end
endmodule