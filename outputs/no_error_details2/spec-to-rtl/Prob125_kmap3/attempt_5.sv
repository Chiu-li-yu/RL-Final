module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);

    // K-map:
    //    cd \ ab | 00 | 01 | 10 | 11
    //    --------+----+----+----+----
    //    00      | d  | 0  | 1  | 1
    //    01      | 0  | 0  | d  | d
    //    11      | 0  | 1  | 1  | 1
    //    10      | 0  | 1  | 1  | 1
    
    // Let's use the simplest SOP:
    // Cells with 1:
    // (a=1, b=0, c=0, d=0) -> a & ~b & ~c & ~d
    // (a=1, b=0, c=1, d=1) -> a & ~b & c & d
    // (a=1, b=0, c=1, d=0) -> a & ~b & c & ~d
    // (a=1, b=1, c=0, d=0) -> a & b & ~c & ~d
    // (a=1, b=1, c=1, d=1) -> a & b & c & d
    // (a=1, b=1, c=1, d=0) -> a & b & c & ~d
    // (a=0, b=1, c=1, d=1) -> ~a & b & c & d
    // (a=0, b=1, c=1, d=0) -> ~a & b & c & ~d
    
    // Groups:
    // a=1 is covered (a)
    // For a=0: (b=1 & c=1) is covered (~a & b & c)
    // Cells:
    // (0,1,1,1) -> ~a & b & c & d
    // (0,1,1,0) -> ~a & b & c & ~d
    // Both covered by (~a & b & c)
    
    // So the function is: a | (b & c)
    // Wait, is there any case where (a | (b & c)) is 0 but it should be 1?
    // Let's re-check (a,b,c,d) = (0,0,0,0).
    // K-map: cd=00, ab=00 is 'd'. So we can choose 0 or 1.
    // If we choose 1, a | (b & c) = 0 | 0 = 0.
    // Maybe we should choose d=1?
    
    // If d (at 0000) = 1, then a | (b & c) = 0 | 0 = 0 is a mismatch.
    // Let's check the rest:
    // (0,1,0,0): a=0, b=1, c=0, d=0 -> out=0.
    // (0,0,1,0): a=0, b=0, c=1, d=0 -> out=0.
    // All seem to match.
    
    // Is it possible the K-map inputs were labeled differently?
    // Columns (ab): 00 01 10 11
    // Rows (cd): 00 01 11 10
    
    // What if the columns/rows were (a,b) and (c,d) in binary?
    // ab=00, 01, 10, 11 (0, 1, 2, 3)
    // cd=00, 01, 11, 10 (0, 1, 3, 2)
    
    always @(*) begin
        out = a | (b & c & ~d) | (b & c & d); 
        // This is a | (b & c)
    end

endmodule