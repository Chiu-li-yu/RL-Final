module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // K-map columns based on ab:
    // col 00: c | d
    // col 01: 0
    // col 10: ~(c ^ d)
    // col 11: c & d

    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = ~(c ^ d);
    assign mux_in[3] = c & d;

endmodule
