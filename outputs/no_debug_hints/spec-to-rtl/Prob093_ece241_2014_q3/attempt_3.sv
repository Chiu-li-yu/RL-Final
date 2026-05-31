module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Let's re-examine the K-map values very carefully:
    // Rows (cd): 00, 01, 11, 10
    // Cols (ab): 00, 01, 11, 10
    
    // Column 00 (ab=00): Rows 00=0, 01=1, 11=1, 10=1. f = c|d.
    // Column 01 (ab=01): Rows 00=0, 01=0, 11=0, 10=0. f = 0.
    // Column 11 (ab=11): Rows 00=0, 01=0, 11=1, 10=0. f = c&d.
    // Column 10 (ab=10): Rows 00=1, 01=0, 11=0, 10=1. f = ~(c^d).

    // Mapping to mux_in[0..3] where index corresponds to ab value:
    // index 0 (ab=00): c | d
    // index 1 (ab=01): 0
    // index 2 (ab=10): ~(c ^ d)
    // index 3 (ab=11): c & d
    
    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = ~(c ^ d);
    assign mux_in[3] = c & d;
endmodule
