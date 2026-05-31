module A(
    input logic x,
    input logic y,
    output logic z
);
    assign z = (x ^ y) & x;
endmodule

module B(
    input logic x,
    input logic y,
    output logic z
);
    assign z = ~(x ^ y);
endmodule

module TopModule(
    input logic x,
    input logic y,
    output logic z
);
    logic outA1, outB1, outA2, outB2;
    logic or_out, and_out;

    A a1(.x(x), .y(y), .z(outA1));
    B b1(.x(x), .y(y), .z(outB1));
    A a2(.x(x), .y(y), .z(outA2));
    B b2(.x(x), .y(y), .z(outB2));

    always @(*) begin
        or_out = outA1 | outB1;
        and_out = outA2 & outB2;
        z = or_out ^ and_out;
    end
endmodule
