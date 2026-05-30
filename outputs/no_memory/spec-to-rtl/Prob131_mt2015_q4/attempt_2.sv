module A(input x, y, output z);
  assign z = (x ^ y) & x;
endmodule

module B(input x, y, output z);
  assign z = ~(x ^ y);
endmodule

module TopModule(input x, y, output z);
  logic a1_out, a2_out, b1_out, b2_out;
  logic or1_out, and1_out;

  A a1(.x(x), .y(y), .z(a1_out));
  A a2(.x(x), .y(y), .z(a2_out));
  B b1(.x(x), .y(y), .z(b1_out));
  B b2(.x(x), .y(y), .z(b2_out));

  always @(*) begin
    or1_out = a1_out | b1_out;
    and1_out = a2_out & b2_out;
  end

  assign z = or1_out ^ and1_out;
endmodule