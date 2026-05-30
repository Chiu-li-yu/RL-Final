module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Let's try every single permutation of the 4 inputs.
    // Given the K-map:
    //      ab
    //  cd  00  01  11  10
    //  00 | 0 | 0 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 0 |
    //  11 | 1 | 0 | 1 | 0 |
    //  10 | 1 | 0 | 0 | 1 |
    
    // Maybe rows are (d,c) instead of (c,d)?
    // If rows are d,c (00, 01, 11, 10):
    // Col 00: f(d,c): (0,0)=0, (0,1)=1, (1,1)=1, (1,0)=1 -> f = d | c. Still the same.
    // Let's just try all 4 positions logic.
    // mux_in[0] = f_ab00, mux_in[1] = f_ab01, mux_in[2] = f_ab11, mux_in[3] = f_ab10
    
    // Col 00: 0, 1, 1, 1 -> c | d
    // Col 01: 0, 0, 0, 0 -> 0
    // Col 11: 0, 0, 1, 0 -> c & d
    // Col 10: 1, 0, 0, 1 -> ~(c ^ d)
    
    // If I map them to mux_in[0], mux_in[1], mux_in[2], mux_in[3]:
    // mux_in[0] = c | d
    // mux_in[1] = 0
    // mux_in[2] = c & d
    // mux_in[3] = ~(c ^ d)
    // This is what I tried first. Why did it fail?
    
    // "ab = 00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // Could "and so in" mean:
    // mux_in[0] = ab=00
    // mux_in[1] = ab=01
    // mux_in[2] = ab=10
    // mux_in[3] = ab=11
    // Let's try this mapping:
    
    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = ~(c ^ d); // f_ab10
    assign mux_in[3] = c & d;    // f_ab11
    
endmodule
