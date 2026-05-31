module SubModuleA (
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module SubModuleB (
    input x,
    input y,
    output z
);
    // Logic analysis of table:
    // x=0, y=0 -> z=1
    // x=1, y=0 -> z=0
    // x=0, y=1 -> z=0
    // x=1, y=1 -> z=1
    // Result: z = ~(x ^ y) which is xNOR
    assign z = ~(x ^ y);
endmodule

module TopModule (
    input x,
    input y,
    output z
);
    logic a1_out, b1_out, a2_out, b2_out;
    logic or_out, and_out;

    SubModuleA A1 (.x(x), .y(y), .z(a1_out));
    SubModuleB B1 (.x(x), .y(y), .z(b1_out));
    
    SubModuleA A2 (.x(x), .y(y), .z(a2_out));
    SubModuleB B2 (.x(x), .y(y), .z(b2_out));

    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out;
endmodule
