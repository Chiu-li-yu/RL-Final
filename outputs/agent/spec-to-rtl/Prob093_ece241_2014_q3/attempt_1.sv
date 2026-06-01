module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // Based on K-map analysis:
    // col 00 (ab=00): c|d
    // col 01 (ab=01): 0
    // col 10 (ab=10): ~(c^d) -> XNOR
    // col 11 (ab=11): c&d
    
    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = ~(c ^ d);
    assign mux_in[3] = c & d;
endmodule
