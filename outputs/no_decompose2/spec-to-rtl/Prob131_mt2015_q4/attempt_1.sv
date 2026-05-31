module SubModuleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module SubModuleB(
    input x,
    input y,
    output z
);
    // x y | z
    // 0 0 | 1
    // 1 0 | 0
    // 0 1 | 0
    // 1 1 | 1
    // Logic: ~(x ^ y)
    assign z = ~(x ^ y);
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    logic a1_out, a2_out, b1_out, b2_out;
    logic or_out, and_out;

    SubModuleA u_a1 (.x(x), .y(y), .z(a1_out));
    SubModuleA u_a2 (.x(x), .y(y), .z(a2_out));
    SubModuleB u_b1 (.x(x), .y(y), .z(b1_out));
    SubModuleB u_b2 (.x(x), .y(y), .z(b2_out));

    always @(*) begin
        or_out = a1_out | b1_out;
        and_out = a2_out & b2_out;
        z = or_out ^ and_out;
    end
endmodule
