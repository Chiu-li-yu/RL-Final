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

    // NOT d
    wire not_d;
    MUX2to1 m3(d, 1'b1, 1'b0, not_d);

    // Mapping based on new analysis:
    // ab=00 -> mux_in[0] = OR = or_out
    // ab=01 -> mux_in[1] = 0
    // ab=10 -> mux_in[2] = NOT d = not_d
    // ab=11 -> mux_in[3] = AND = and_out
    
    assign mux_in[0] = or_out;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = not_d;
    assign mux_in[3] = and_out;
endmodule
