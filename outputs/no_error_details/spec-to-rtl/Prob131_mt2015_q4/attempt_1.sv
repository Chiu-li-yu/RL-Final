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
    logic a1_z, a2_z, b1_z, b2_z;
    logic or_out, and_out;

    ModuleA A1 (.x(x), .y(y), .z(a1_z));
    ModuleA A2 (.x(x), .y(y), .z(a2_z));
    ModuleB B1 (.x(x), .y(y), .z(b1_z));
    ModuleB B2 (.x(x), .y(y), .z(b2_z));

    always @(*) begin
        or_out = a1_z | b1_z;
        and_out = a2_z & b2_z;
    end

    assign z = or_out ^ and_out;
endmodule