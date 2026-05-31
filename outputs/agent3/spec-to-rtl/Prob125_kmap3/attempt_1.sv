module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Based on K-map:
    // (a,b,c,d) = (c,d,a,b) row c,d col a,b
    // cd=00, ab=00 -> 0
    // cd=00, ab=01 -> d (don't care)
    // cd=00, ab=10 -> 1
    // cd=00, ab=11 -> 1
    // cd=01, ab=00 -> 0
    // cd=01, ab=01 -> 0
    // cd=01, ab=10 -> d
    // cd=01, ab=11 -> d
    // cd=11, ab=00 -> 0
    // cd=11, ab=01 -> 1
    // cd=11, ab=10 -> 1
    // cd=11, ab=11 -> 1
    // cd=10, ab=00 -> 0
    // cd=10, ab=01 -> 1
    // cd=10, ab=10 -> 1
    // cd=11, ab=11 -> 1
    
    // Simplification (treating d as 0 if possible, or 1 if useful for coverage):
    // Trying to fit: out = a | (c & b)
    
    always @(*) begin
        out = a | (c & b);
    end
endmodule
