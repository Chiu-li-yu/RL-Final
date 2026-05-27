module SubModuleA(
    input logic x,
    input logic y,
    output logic z
);
    always @(*) begin
        z = (x ^ y) & x;
    end
endmodule

module SubModuleB(
    input logic x,
    input logic y,
    output logic z
);
    // Truth table derived from waveform:
    // x y | z
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 1
    // This is equivalent to !(x ^ y) or (x == y)
    always @(*) begin
        z = ~(x ^ y);
    end
endmodule

module TopModule(
    input logic x,
    input logic y,
    output logic z
);
    logic a1_out, b1_out, a2_out, b2_out;
    logic or_out, and_out;

    SubModuleA A1 (.x(x), .y(y), .z(a1_out));
    SubModuleB B1 (.x(x), .y(y), .z(b1_out));
    SubModuleA A2 (.x(x), .y(y), .z(a2_out));
    SubModuleB B2 (.x(x), .y(y), .z(b2_out));

    always @(*) begin
        or_out = a1_out | b1_out;
        and_out = a2_out & b2_out;
        z = or_out ^ and_out;
    end
endmodule
