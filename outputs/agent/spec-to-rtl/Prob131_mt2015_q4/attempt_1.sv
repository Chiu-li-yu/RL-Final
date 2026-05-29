
module ModuleA (
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module ModuleB (
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);
endmodule

module TopModule (
    input x,
    input y,
    output z
);
    logic a1, b1, a2, b2;
    logic or_out, and_out;

    ModuleA inst_a1 (.x(x), .y(y), .z(a1));
    ModuleB inst_b1 (.x(x), .y(y), .z(b1));
    ModuleA inst_a2 (.x(x), .y(y), .z(a2));
    ModuleB inst_b2 (.x(x), .y(y), .z(b2));

    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign z = or_out ^ and_out;
endmodule
