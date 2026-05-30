module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    // Let's re-read the K-map very carefully:
    //      ab
    //  cd  00  01  11  10
    //  00 | 0 | 0 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 0 |
    //  11 | 1 | 0 | 1 | 0 |
    //  10 | 1 | 0 | 0 | 1 |

    // The columns are defined as ab.
    // If a 4-to-1 multiplexer has selector {a, b}:
    // Selector 00 (a=0, b=0) -> mux_in[0]
    // Selector 01 (a=0, b=1) -> mux_in[1]
    // Selector 10 (a=1, b=0) -> mux_in[2]  <-- WAIT! Mux usually selects 00, 01, 10, 11
    // Selector 11 (a=1, b=1) -> mux_in[3]  <-- WAIT!

    // The K-map columns are listed as: 00, 01, 11, 10
    // If our multiplexer uses standard selection:
    // Selector 00 -> connects input 0
    // Selector 01 -> connects input 1
    // Selector 10 -> connects input 2
    // Selector 11 -> connects input 3

    // Mapping K-map columns to Mux selection:
    // Column 00 (ab=00) -> Mux Selector 00 (index 0)
    // Column 01 (ab=01) -> Mux Selector 01 (index 1)
    // Column 11 (ab=11) -> Mux Selector 11 (index 3)
    // Column 10 (ab=10) -> Mux Selector 10 (index 2)

    // Wait, let's re-verify the values for each Mux input index:
    // mux_in[0] (ab=00): rows cd=00,01,11,10 -> 0,1,1,1.   c|d is (0,1,1,1) -> CORRECT.
    // mux_in[1] (ab=01): rows cd=00,01,11,10 -> 0,0,0,0.   0 is (0,0,0,0) -> CORRECT.
    // mux_in[2] (ab=10): rows cd=00,01,11,10 -> 1,0,0,1.   c^d is (0,1,1,0), so ~(c^d) is (1,0,0,1) -> CORRECT.
    // mux_in[3] (ab=11): rows cd=00,01,11,10 -> 0,0,1,0.   c&d is (0,0,1,0) -> CORRECT.
    
    // Everything seems correct. Why the mismatch?
    // Could it be that the mux selector is {b, a} instead of {a, b}?
    // Or maybe the mux indices are different? "ab=00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // "and so in" might imply index 2 is ab=10 and index 3 is ab=11.
    // Let me try swapping 2 and 3.

    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[3] = ~(c ^ d); // Try swapping index 2 and 3
    assign mux_in[2] = c & d;
endmodule
