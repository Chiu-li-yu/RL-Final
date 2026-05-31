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
    // OR(c, d) using 1 MUX2to1: select=c, in1=1, in0=d
    wire or_out;
    MUX2to1 m1(c, d, 1'b1, or_out);

    // AND(c, d) using 1 MUX2to1: select=c, in1=d, in0=0
    wire and_out;
    MUX2to1 m2(c, 1'b0, d, and_out);

    // XNOR(c, d) = NOT(c XOR d). 
    // First, generate not_d = MUX2to1(d, 1, 0)
    wire not_d;
    MUX2to1 m3(d, 1'b1, 1'b0, not_d);
    // XNOR = MUX2to1(c, d, not_d)
    wire xnor_out;
    MUX2to1 m4(c, d, not_d, xnor_out);

    // mux_in[0] (ab=00) = OR = or_out
    // mux_in[1] (ab=01) = 0
    // mux_in[2] (ab=11) = AND = and_out
    // mux_in[3] (ab=10) = XNOR = xnor_out
    assign mux_in[0] = or_out;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = and_out;
    assign mux_in[3] = xnor_out;
endmodule
