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
    // 00 | 1  | 1  | 0  | 1
    // 01 | 1  | 0  | 0  | 1
    // 11 | 0  | 1  | 1  | 1
    // 10 | 1  | 1  | 0  | 0

    // Logic implementation
    always @(*) begin
        out = (~a & ~b & ~c & ~d) | 
              (~a & ~b & ~c & d) | 
              (~a & b & ~c & ~d) | 
              (~a & b & c & d) | 
              (a & ~b & ~c & ~d) | 
              (a & ~b & ~c & d) | 
              (a & b & c & d) | 
              (a & b & c & ~d) | 
              (a & ~b & c & d);
    end
endmodule
