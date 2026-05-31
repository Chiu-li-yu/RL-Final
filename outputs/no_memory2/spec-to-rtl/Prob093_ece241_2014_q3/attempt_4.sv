module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    // Based on the K-map:
    // ab=00 (mux_in[0]): cd=00->0, 01->1, 11->1, 10->1 => F = c | d
    // ab=01 (mux_in[1]): cd=00->0, 01->0, 11->0, 10->0 => F = 0
    // ab=10 (mux_in[2]): cd=00->1, 01->0, 11->0, 10->1 => F = ~(c ^ d)
    // ab=11 (mux_in[3]): cd=00->0, 01->0, 11->1, 10->0 => F = c & d

    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = ~(c ^ d);
    assign mux_in[3] = c & d;

endmodule
