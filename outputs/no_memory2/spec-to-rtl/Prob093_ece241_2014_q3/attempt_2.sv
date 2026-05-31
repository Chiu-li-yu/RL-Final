module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // K-map (cd/ab):
    //       ab
    //   cd  00  01  11  10
    //   00 | 0 | 0 | 0 | 1 |
    //   01 | 1 | 0 | 0 | 0 |
    //   11 | 1 | 0 | 1 | 0 |
    //   10 | 1 | 0 | 0 | 1 |
    //
    // Columns (ab):
    // 00: mux_in[0] = f(c,d) = (c=0, d=1) | (c=1, d=1) | (c=1, d=0) = (!c&d) | (c&d) | (c&!d) = c | d
    // 01: mux_in[1] = f(c,d) = 0
    // 11: mux_in[2] = f(c,d) = (c=1, d=1) = c&d
    // 10: mux_in[3] = f(c,d) = (c=0, d=0) | (c=1, d=0) = (!c&!d) | (c&!d) = !d

    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c & d;
    assign mux_in[3] = ~d;

endmodule
