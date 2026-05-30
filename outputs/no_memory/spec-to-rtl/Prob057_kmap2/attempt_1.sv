module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map table (ab vs cd):
    //       ab
    // cd | 00 | 01 | 11 | 10
    // ---+----+----+----+----
    // 00 | 1  | 1  | 0  | 1
    // 01 | 1  | 0  | 0  | 1
    // 11 | 0  | 1  | 1  | 1
    // 10 | 1  | 1  | 0  | 0
    
    // Minterms where out=1:
    // (a,b,c,d)
    // 0000, 0100, 1000
    // 0001, 1001
    // 0111, 1111, 1011
    // 0010, 0110
    
    // Simplified Logic:
    // out = (~a & ~c & ~d) | (~a & ~b & ~d) | ... (Use Karnaugh Map grouping)
    // Looking at the map:
    // 1s are at:
    // (0,0,0,0), (0,1,0,0), (1,0,0,0) -> ~c&~d & (~a&~b | ~a&b | a&~b) = ~c&~d & (~a | ~b)
    // (0,0,0,1), (1,0,0,1) -> ~c&d & (~a&~b | a&~b) = ~c&d & ~b
    // (0,1,1,1), (1,1,1,1), (1,0,1,1) -> c&d & (a&b | ~a&b | a&~b) = c&d & (a|b)
    // (0,0,1,0), (0,1,1,0) -> c&~d & (~a&~b | ~a&b) = c&~d & ~a
    
    assign out = (~c & ~d & (~a | ~b)) | (~c & d & ~b) | (c & d & (a | b)) | (c & ~d & ~a);
endmodule
