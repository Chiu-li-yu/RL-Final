module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // mux_in[0] (ab=00): row entries {0, 1, 1, 1} for cd {00, 01, 11, 10} => c | d
    // mux_in[1] (ab=01): row entries {0, 0, 0, 0} => 0
    // mux_in[2] (ab=11): row entries {0, 0, 1, 0} => c & d
    // mux_in[3] (ab=10): row entries {1, 0, 0, 1} => ~(c ^ d)

    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c & d;
    assign mux_in[3] = ~(c ^ d);

endmodule