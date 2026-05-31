module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Let's re-read the table:
    //      ab
    //  cd  00  01  11  10
    //  00 | 0 | 0 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 0 |
    //  11 | 1 | 0 | 1 | 0 |
    //  10 | 1 | 0 | 0 | 1 |
    
    // Maybe the mux_in mapping is simply column by column, from left to right?
    // Col 0 (ab=00): [0, 1, 1, 1]  (cd=00, 01, 11, 10)
    // Col 1 (ab=01): [0, 0, 0, 0]
    // Col 2 (ab=11): [0, 0, 1, 0]
    // Col 3 (ab=10): [1, 0, 0, 1]
    
    // Wait, the K-map values:
    // If cd is rows:
    // cd=00 -> ab 00=0, 01=0, 11=0, 10=1  => (ab == 10)
    // cd=01 -> ab 00=1, 01=0, 11=0, 10=0  => (ab == 00)
    // cd=11 -> ab 00=1, 01=0, 11=1, 10=0  => (ab == 00 | ab == 11)
    // cd=10 -> ab 00=1, 01=0, 11=0, 10=1  => (ab == 00 | ab == 10)
    
    // If we define functions for each column:
    // Col 00: f(ab=00) = (cd==01 | cd==11 | cd==10) = (cd != 00) = c | d
    // Col 01: f(ab=01) = 0
    // Col 11: f(ab=11) = (cd==11) = c & d
    // Col 10: f(ab=10) = (cd==00 | cd==10) = ~c & ~d | c & ~d = ~d
    
    // Let's re-check f(10) (col 10).
    // cd=00 (f=1), 01(f=0), 11(f=0), 10(f=1).
    // Yes, this is ~d.
    
    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = ~d; // This was ~(c^d)
    assign mux_in[3] = c & d;

endmodule
