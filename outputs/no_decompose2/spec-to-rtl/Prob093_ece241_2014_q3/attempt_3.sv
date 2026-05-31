module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Let's re-examine the K-map carefully.
    //      ab
    //  cd  00  01  11  10
    //  00 | 0 | 0 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 0 |
    //  11 | 1 | 0 | 1 | 0 |
    //  10 | 1 | 0 | 0 | 1 |

    // The columns are:
    // col 0 (ab=00): {0, 1, 1, 1} -> c|d
    // col 1 (ab=01): {0, 0, 0, 0} -> 0
    // col 2 (ab=11): {0, 0, 1, 0} -> c&d
    // col 3 (ab=10): {1, 0, 0, 1} -> ~(c^d)

    // The problem states:
    // "The mux takes as input {a,b} and ab = 00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // This usually means:
    // mux_in[0] for ab=00
    // mux_in[1] for ab=01
    // mux_in[2] for ab=10
    // mux_in[3] for ab=11

    // So:
    // mux_in[0] = col 0 = c | d
    // mux_in[1] = col 1 = 0
    // mux_in[2] = col 3 = ~(c ^ d)
    // mux_in[3] = col 2 = c & d

    always @(*) begin
        mux_in[0] = c | d;
        mux_in[1] = 1'b0;
        mux_in[2] = ~(c ^ d);
        mux_in[3] = c & d;
    end
endmodule
