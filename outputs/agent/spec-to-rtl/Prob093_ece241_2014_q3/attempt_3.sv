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
    // Re-check the table carefully:
    //      ab
    //  cd  00  01  11  10
    //  00 | 0 | 0 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 0 |
    //  11 | 1 | 0 | 1 | 1 |
    //  10 | 1 | 0 | 0 | 1 |
    
    // The problem statement says:
    // "The mux takes as input {a,b} and ab = 00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // This usually means [a,b] are inputs to the 4-to-1 mux, but in THIS context, the K-map has columns "00 01 11 10".
    // Wait, the column order in the table IS ab=00, ab=01, ab=11, ab=10.
    // So:
    // mux_in[0] corresponds to ab=00 column
    // mux_in[1] corresponds to ab=01 column
    // mux_in[2] corresponds to ab=11 column
    // mux_in[3] corresponds to ab=10 column

    // Let's re-verify the values for each mux_in:
    // cd | 00 01 11 10
    // 00 | 0  0  0  1
    // 01 | 1  0  0  0
    // 11 | 1  0  1  1
    // 10 | 1  0  0  1

    // column ab=00: [0, 1, 1, 1] for cd=[00, 01, 11, 10]
    // wait, cd mapping:
    // c d | f
    // 0 0 | 0
    // 0 1 | 1
    // 1 0 | 1
    // 1 1 | 1
    // This is f = c | d. Correct.

    // column ab=01: [0, 0, 0, 0]
    // f = 0. Correct.

    // column ab=11: [0, 0, 1, 0]
    // c d | f
    // 0 0 | 0
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 1
    // f = c & d. Correct.

    // column ab=10: [1, 0, 1, 1]
    // c d | f
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 1
    // 1 1 | 1
    // f = c | !d. Correct.

    // The mapping of mux_in to ab:
    // ab=00 -> mux_in[0]
    // ab=01 -> mux_in[1]
    // ab=10 -> mux_in[2]
    // ab=11 -> mux_in[3]

    // Ah! The problem states: "ab=00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // "And so in" could imply:
    // mux_in[0] -> ab=00
    // mux_in[1] -> ab=01
    // mux_in[2] -> ab=10
    // mux_in[3] -> ab=11

    // My previous mapping was:
    // mux_in[2] was ab=11
    // mux_in[3] was ab=10
    // Let's swap them!

    logic m0_out, m1_out, m2_out, m3_out;
    Mux2to1 inst0 (.a(d), .b(1'b1), .sel(c), .out(m0_out)); // ab=00
    assign m1_out = 1'b0;                                   // ab=01
    Mux2to1 inst2 (.a(1'b1), .b(c), .sel(d), .out(m2_out)); // ab=10
    Mux2to1 inst3 (.a(1'b0), .b(d), .sel(c), .out(m3_out)); // ab=11

    assign mux_in[0] = m0_out;
    assign mux_in[1] = m1_out;
    assign mux_in[2] = m2_out;
    assign mux_in[3] = m3_out;

endmodule
