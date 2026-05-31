module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // Based on the assumption that mux_in[0..3] corresponds to ab=00, 01, 10, 11
    // Mux[0] (ab=00): {0, 1, 1, 1} -> c|d
    // Mux[1] (ab=01): {0, 0, 0, 0} -> 0
    // Mux[2] (ab=10): {1, 0, 0, 1} -> ~(c^d)
    // Mux[3] (ab=11): {0, 0, 1, 0} -> c&d
    
    assign mux_in[0] = (c | d);
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = ~(c ^ d);
    assign mux_in[3] = (c & d);

endmodule
