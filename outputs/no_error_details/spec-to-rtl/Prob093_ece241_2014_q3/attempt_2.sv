module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // K-map:
    //      ab
    //  cd  00  01  11  10
    //  00 | 0 | 0 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 0 |
    //  11 | 1 | 0 | 1 | 0 |
    //  10 | 1 | 0 | 0 | 1 |

    // When ab=00 (mux_in[0]): 
    // cd=00->0, 01->1, 11->1, 10->1
    // Logic: c | d
    assign mux_in[0] = c | d;

    // When ab=01 (mux_in[1]):
    // cd=00->0, 01->0, 11->0, 10->0
    // Logic: 0
    assign mux_in[1] = 1'b0;

    // When ab=11 (mux_in[2]):
    // cd=00->0, 01->0, 11->1, 10->0
    // Logic: c & d
    assign mux_in[2] = c & d;

    // When ab=10 (mux_in[3]):
    // cd=00->1, 01->0, 11->0, 10->1
    // Logic: ~(c ^ d)
    assign mux_in[3] = ~(c ^ d);

endmodule