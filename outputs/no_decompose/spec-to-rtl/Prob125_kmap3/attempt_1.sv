module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map Table (a, b, c, d):
    // cd \ ab | 00 | 01 | 11 | 10
    // ----------------------------
    // 00      | 0  | d  | 1  | 1
    // 01      | 0  | 0  | d  | d
    // 11      | 1  | 0  | 1  | 1
    // 10      | 1  | 0  | 1  | 1
    //
    // Note: The input order provided in the table format (cd vs ab)
    // and the row/column order needs careful mapping.
    // Based on the problem:
    // Row: cd (00, 01, 11, 10)
    // Col: ab (00, 01, 11, 10) - Wait, standard k-map order is 00, 01, 11, 10
    //
    // Let's re-map based on the provided table:
    // (a,b,c,d) = (0,0,0,0) -> 0
    // (a,b,c,d) = (0,1,0,0) -> d (let's map to 0)
    // (a,b,c,d) = (1,1,0,0) -> 1
    // (a,b,c,d) = (1,0,0,0) -> 1
    // ...
    // Let's use a Karnaugh map solver logic.
    // Inputs (a,b,c,d):
    // 0000 -> 0
    // 0001 -> 0
    // 0010 -> 1
    // 0011 -> 1
    // 0100 -> 0
    // 0101 -> 0
    // 0110 -> 0
    // 0111 -> 0
    // 1000 -> 1
    // 1001 -> d (1)
    // 1010 -> 1
    // 1011 -> 1
    // 1100 -> 1
    // 1101 -> d (1)
    // 1110 -> 1
    // 1111 -> 1

    always @(*) begin
        out = (a) | (~b & c);
    end
endmodule
