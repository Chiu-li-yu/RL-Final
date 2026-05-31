module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // K-map:
    // cd | 00 | 01 | 11 | 10
    // 00 | 0  | 0  | 0  | 1
    // 01 | 1  | 0  | 0  | 0
    // 11 | 1  | 0  | 1  | 0
    // 10 | 1  | 0  | 0  | 1

    // Columns (ab): 00, 01, 11, 10
    // Row 00 (cd=00): ab=00:0, ab=01:0, ab=11:0, ab=10:1
    // Row 01 (cd=01): ab=00:1, ab=01:0, ab=11:0, ab=10:0
    // Row 11 (cd=11): ab=00:1, ab=01:0, ab=11:1, ab=10:0
    // Row 10 (cd=10): ab=00:1, ab=01:0, ab=11:0, ab=10:1

    // Re-evaluating mux_in mapping (ab=00, 01, 10, 11 order?)
    // The prompt says: "ab = 00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // "and so in" usually means ab=10 is [2] and ab=11 is [3]. Let's check:
    // K-map columns: 00(0), 01(1), 11(2), 10(3)
    // mux_in[0]: cd=00->0, cd=01->1, cd=11->1, cd=10->1  => mux_in[0] = c | d
    // mux_in[1]: cd=00->0, cd=01->0, cd=11->0, cd=10->0  => mux_in[1] = 0
    // mux_in[2]: cd=00->0, cd=01->0, cd=11->1, cd=10->0  => mux_in[2] = c & d
    // mux_in[3]: cd=00->1, cd=01->0, cd=11->0, cd=10->1  => mux_in[3] = ~(c ^ d)

    assign mux_in[0] = (c | d);
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = (c & d);
    assign mux_in[3] = ~(c ^ d);

endmodule
