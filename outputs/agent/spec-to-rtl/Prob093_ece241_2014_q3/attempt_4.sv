module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Let's re-read the K-map carefully:
    //      ab
    //  cd  00  01  11  10
    //  00 | 0 | 0 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 0 |
    //  11 | 1 | 0 | 1 | 0 |
    //  10 | 1 | 0 | 0 | 1 |

    // ab=00: (cd=00:0, 01:1, 11:1, 10:1) -> c | d
    // ab=01: (cd=00:0, 01:0, 11:0, 10:0) -> 0
    // ab=11: (cd=00:0, 01:0, 11:1, 10:0) -> c & d
    // ab=10: (cd=00:1, 01:0, 11:0, 10:1) -> ~(c^d)

    // The order in the description says:
    // mux_in[0] = ab=00
    // mux_in[1] = ab=01
    // mux_in[2] = ab=10
    // mux_in[3] = ab=11

    always @(*) begin
        mux_in[0] = c | d;
        mux_in[1] = 1'b0;
        mux_in[2] = ~(c ^ d);
        mux_in[3] = c & d;
    end
endmodule
