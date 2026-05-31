module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // Let's re-verify the K-map mapping:
    // Columns: ab=00(0), ab=01(1), ab=11(2), ab=10(3)
    // mux_in[0] (ab=00):
    //   cd=00: 0
    //   cd=01: 1
    //   cd=11: 1
    //   cd=10: 1
    //   Result: c | d

    // mux_in[1] (ab=01):
    //   cd=00: 0
    //   cd=01: 0
    //   cd=11: 0
    //   cd=10: 0
    //   Result: 0

    // mux_in[2] (ab=11):
    //   cd=00: 0
    //   cd=01: 0
    //   cd=11: 1
    //   cd=10: 0
    //   Result: c & d

    // mux_in[3] (ab=10):
    //   cd=00: 1
    //   cd=01: 0
    //   cd=11: 0
    //   cd=10: 1
    //   Result: ~(c ^ d)

    // The order in the prompt: "ab = 00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // This implies mux_in[2] is ab=11 and mux_in[3] is ab=10.
    
    assign mux_in[0] = (c | d);
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = (c & d);
    assign mux_in[3] = (c ~^ d); // Equivalence: c == d

endmodule
