module SubA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module SubB(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    logic a1_out, a2_out, b1_out, b2_out;
    logic or_out, and_out;

    SubA A1(.x(x), .y(y), .z(a1_out));
    SubA A2(.x(x), .y(y), .z(a2_out));
    SubB B1(.x(x), .y(y), .z(b1_out));
    SubB B2(.x(x), .y(y), .z(b2_out));

    always @(*) begin
        or_out = a1_out | b1_out;
        and_out = a2_out & b2_out;
    end

    assign z = or_out ^ and_out;
endmodule