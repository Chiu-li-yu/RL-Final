module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Let's re-read:
    // "ab=00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // Could it be that ab is actually BA? The mux selectors are a and b.
    // If the selector is {a, b}, then:
    // ab=00, 01, 10, 11
    
    // K-map columns: 00, 01, 11, 10
    // If ab is {a, b}:
    // Column 0 (00): 0 | 1 | 1 | 1 -> c|d
    // Column 1 (01): 0 | 0 | 0 | 0 -> 0
    // Column 2 (10): 1 | 0 | 0 | 1 -> ~(c^d)
    // Column 3 (11): 0 | 0 | 1 | 0 -> c&d

    // mux_in[0] = col 0 = c|d
    // mux_in[1] = col 1 = 0
    // mux_in[2] = col 2 = ~(c^d)
    // mux_in[3] = col 3 = c&d
    
    always @(*) begin
        mux_in[0] = c | d;
        mux_in[1] = 1'b0;
        mux_in[2] = ~(c ^ d);
        mux_in[3] = c & d;
    end
endmodule
