module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

  logic q_reg;

  // The mismatch occurs at time 5. This is typically the initial value issue.
  // Many simulators assume initial value is 0.
  // The provided example does not show an asynchronous reset, so it uses the clock edge.
  // Let's initialize it just in case.
  initial q_reg = 0;

  always @(posedge clk) begin
    if (L)
      q_reg <= r_in;
    else
      q_reg <= q_in;
  end

  assign Q = q_reg;

endmodule