module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    logic out_temp;

    always @(*) begin
        // K-map table analysis:
        // Mapping (a,b,c,d) to index:
        // (0,0,0,0) -> 1
        // (0,0,0,1) -> 1
        // (0,0,1,1) -> 0
        // (0,0,1,0) -> 1
        // (0,1,0,0) -> 1
        // (0,1,0,1) -> 0
        // (0,1,1,1) -> 1
        // (0,1,1,0) -> 1
        // (1,1,0,0) -> 0
        // (1,1,0,1) -> 0
        // (1,1,1,1) -> 1
        // (1,1,1,0) -> 0
        // (1,0,0,0) -> 1
        // (1,0,0,1) -> 1
        // (1,0,1,1) -> 1
        // (1,0,1,0) -> 0

        // Karnaugh map cells (row:cd, col:ab)
        // 00 00 -> 1
        // 00 01 -> 1
        // 00 11 -> 0
        // 00 10 -> 1

        // 01 00 -> 1
        // 01 01 -> 0
        // 01 11 -> 0
        // 01 10 -> 1

        // 11 00 -> 0
        // 11 01 -> 1
        // 11 11 -> 1
        // 11 10 -> 1

        // 10 00 -> 1
        // 10 01 -> 1
        // 10 11 -> 0
        // 10 10 -> 0

        // Simplification:
        // Logic expression derived from K-map:
        // out = (~b & ~c) | (a & ~c & d) | (~a & b & c) | (b & c & d) | (~a & ~d)
        // Let's re-verify:
        // Cells with 1:
        // 0,0,0,0: 1
        // 0,0,0,1: 1
        // 0,0,1,0: 1
        // 0,1,0,0: 1
        // 0,1,1,0: 1
        // 0,1,1,1: 1
        // 1,1,1,1: 1
        // 1,1,0,1: 0 (Wait, 1,1,0,1 is index 13, cd=01, ab=11, looking at map: cd=01(row 1), ab=11(col 2) -> 0. Correct.)
        // 1,1,1,1 is index 15, cd=11, ab=11, map: 1. Correct.
        // Let's use SOP based on truth table for safety.
        
        out_temp = (~a & ~b & ~c & ~d) | (~a & ~b & ~c &  d) | (~a & ~b &  c & ~d) | 
                   (~a &  b & ~c & ~d) | (~a &  b &  c & ~d) | (~a &  b &  c &  d) |
                   ( a &  b &  c &  d) | 
                   ( a & ~b & ~c & ~d) | ( a & ~b & ~c &  d) | ( a & ~b &  c &  d);
                   
        // Minimized SOP:
        // out = (~a & ~c) | (b & c & d) | (a & ~b & ~c) | (a & ~b & d) | (~a & b & ~d)
        // Let's just use the boolean representation of the K-map directly.
    end
    
    assign out = out_temp;
endmodule
