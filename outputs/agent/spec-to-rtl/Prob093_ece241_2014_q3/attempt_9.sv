module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Maybe the mux_in is defined differently?
    // "ab = 00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // This could mean:
    // mux_in[0] = f when ab=00
    // mux_in[1] = f when ab=01
    // mux_in[2] = f when ab=10
    // mux_in[3] = f when ab=11
    
    // AND:
    // Col 00: f=c|d
    // Col 01: f=0
    // Col 11: f=c&d
    // Col 10: f=~(c^d)
    
    // My code was:
    // assign mux_in[0] = c | d;
    // assign mux_in[1] = 1'b0;
    // assign mux_in[2] = ~(c^d); // This was col 10
    // assign mux_in[3] = c & d;  // This was col 11
    
    // This gave 27 mismatches.
    
    // Let's try to swap [2] and [3]:
    // mux_in[0] = c | d
    // mux_in[1] = 0
    // mux_in[2] = c & d
    // mux_in[3] = ~(c^d)
    // This gave 38 mismatches.
    
    // Let's re-try the "swap [2] and [3]" but for other combinations.
    // What if the row order is NOT 00, 01, 11, 10?
    // What if the row order is 00, 10, 11, 01?
    
    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c & d;
    assign mux_in[3] = ~(c ^ d);

endmodule
