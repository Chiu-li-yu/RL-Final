module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // Based on K-map analysis:
    // ab=00 -> mux_in[0] = c | d
    // ab=01 -> mux_in[1] = 0
    // ab=11 -> mux_in[2] = c & d
    // ab=10 -> mux_in[3] = ~(c ^ d)
    
    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c & d;
    assign mux_in[3] = ~(c ^ d);
endmodule
