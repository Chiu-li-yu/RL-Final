module Mux2to1 (
    input a,
    input b,
    input sel,
    output logic out
);
    assign out = sel ? b : a;
endmodule

module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // K-map (cd as rows, ab as cols):
    //      ab
    //  cd  00  01  11  10
    //  00  0   0   0   1
    //  01  1   0   0   0
    //  11  1   0   1   1
    //  10  1   0   0   1

    // Columns are ab:
    // col 0 (ab=00): [0, 1, 1, 1] for cd = [00, 01, 11, 10]
    // col 1 (ab=01): [0, 0, 0, 0] for cd = [00, 01, 11, 10]
    // col 2 (ab=11): [0, 0, 1, 0] for cd = [00, 01, 11, 10]
    // col 3 (ab=10): [1, 0, 1, 1] for cd = [00, 01, 11, 10]

    // Implement mux_in[0] (ab=00) using muxes:
    // row 00: 0
    // row 01: 1
    // row 11: 1
    // row 10: 1
    // This is (c or d).
    // Using 2-to-1 muxes for (c or d):
    // (c or d) = Mux(d, 1, c)
    logic m0_out;
    Mux2to1 inst0 (.a(d), .b(1'b1), .sel(c), .out(m0_out));
    assign mux_in[0] = m0_out;

    // Implement mux_in[1] (ab=01): All 0
    assign mux_in[1] = 1'b0;

    // Implement mux_in[2] (ab=11):
    // row 00: 0
    // row 01: 0
    // row 11: 1
    // row 10: 0
    // This is (c and d).
    // (c and d) = Mux(0, d, c)
    logic m2_out;
    Mux2to1 inst2 (.a(1'b0), .b(d), .sel(c), .out(m2_out));
    assign mux_in[2] = m2_out;

    // Implement mux_in[3] (ab=10):
    // row 00: 1
    // row 01: 0
    // row 11: 1
    // row 10: 1
    // This is (!d or c) or (c or !d).
    // (c or !d) = Mux(1, c, d)
    logic m3_out;
    Mux2to1 inst3 (.a(1'b1), .b(c), .sel(d), .out(m3_out));
    assign mux_in[3] = m3_out;

endmodule
