module Module_A(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module Module_B(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);
endmodule

module TopModule(
    input x,
    input y,
    output logic z
);
    logic outA1, outB1, outA2, outB2;
    logic OR1, AND1;

    Module_A A1 (.x(x), .y(y), .z(outA1));
    Module_B B1 (.x(x), .y(y), .z(outB1));
    Module_A A2 (.x(x), .y(y), .z(outA2));
    Module_B B2 (.x(x), .y(y), .z(outB2));

    always @(*) begin
        OR1 = outA1 | outB1;
        AND1 = outA2 & outB2;
        z = OR1 ^ AND1;
    end
endmodule
