module MUX2to1(
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = (sel) ? in1 : in0;
endmodule

module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    // OR(c, d)
    wire or_out;
    MUX2to1 m1(c, d, 1'b1, or_out);

    // AND(c, d)
    wire and_out;
    MUX2to1 m2(c, 1'b0, d, and_out);

    // XNOR(c, d)
    wire not_d;
    MUX2to1 m3(d, 1'b1, 1'b0, not_d);
    wire xnor_out;
    MUX2to1 m4(c, d, not_d, xnor_out);

    // Re-mapping based on: ab 00, 01, 11, 10 -> index 0, 1, 2, 3
    assign mux_in[0] = or_out;    // ab=00 -> c|d
    assign mux_in[1] = 1'b0;      // ab=01 -> 0
    assign mux_in[2] = and_out;   // ab=11 -> c&d
    assign mux_in[3] = xnor_out;  // ab=10 -> ~(c^d)
endmodule
