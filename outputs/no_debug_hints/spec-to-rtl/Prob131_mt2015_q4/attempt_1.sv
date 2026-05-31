module ModuleA(input x, input y, output z);
  assign z = (x ^ y) & x;
endmodule

module ModuleB(input x, input y, output z);
  assign z = ~(x ^ y);
endmodule

module TopModule(input x, input y, output z);
  logic out_A1, out_A2, out_B1, out_B2;
  logic out_OR, out_AND;

  ModuleA A1(.x(x), .y(y), .z(out_A1));
  ModuleA A2(.x(x), .y(y), .z(out_A2));
  ModuleB B1(.x(x), .y(y), .z(out_B1));
  ModuleB B2(.x(x), .y(y), .z(out_B2));

  always @(*) begin
    out_OR = out_A1 | out_B1;
    out_AND = out_A2 & out_B2;
  end

  assign z = out_OR ^ out_AND;
endmodule
