module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);
    // Karnaugh Map:
    // Row/Col order based on table provided:
    // Map indices: cd (row) / ab (col)
    // Table content:
    //      ab
    // cd | 00 | 01 | 11 | 10
    // 00 | 0  | d  | 1  | 1
    // 01 | 0  | 0  | d  | d
    // 11 | 1  | 0  | 1  | 1
    // 10 | 1  | 0  | 1  | 1
    // (Wait, the input table has columns: 01, 00, 10, 11)
    // Corrected Table Mapping:
    //      ab: 01   00   10   11
    // cd:00 |  d  |  0  |  1  |  1
    // cd:01 |  0  |  0  |  d  |  d
    // cd:11 |  1  |  0  |  1  |  1
    // cd:10 |  1  |  0  |  1  |  1
    
    // Logic extraction:
    // 1s are at (c=0,d=0,a=1,b=0), (c=0,d=0,a=1,b=1)
    //           (c=1,d=1,a=0,b=1), (c=1,d=1,a=1,b=1), (c=1,d=1,a=1,b=0)
    //           (c=1,d=0,a=0,b=1), (c=1,d=0,a=1,b=1), (c=1,d=0,a=1,b=0)

    always @(*) begin
        out = (a & ~c & ~d) | (a & c) | (b & c & ~d) | (a & b & c);
    end
endmodule