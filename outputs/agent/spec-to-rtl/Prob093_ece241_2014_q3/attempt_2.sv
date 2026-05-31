module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // K-map order: 00, 01, 11, 10
    // Col 00: c|d
    // Col 01: 0
    // Col 11: c&d
    // Col 10: ~(c^d)
    
    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c & d;
    assign mux_in[3] = ~(c ^ d);
endmodule
