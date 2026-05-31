module ModuleA(input x, input y, output z);
  assign z = (x ^ y) & x;
endmodule

module ModuleB(input x, input y, output z);
  assign z = ~(x ^ y);
endmodule

module TopModule(input x, input y, output z);
  logic z1, z2, z3, z4;
  logic OR_out, AND_out;

  ModuleA A1(.x(x), .y(y), .z(z1));
  ModuleB B1(.x(x), .y(y), .z(z2));
  ModuleA A2(.x(x), .y(y), .z(z3));
  ModuleB B2(.x(x), .y(y), .z(z4));

  always @(*) begin
    OR_out = z1 | z2;
    AND_out = z3 & z4;
  end

  assign z = OR_out ^ AND_out;
endmodule
