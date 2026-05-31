module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

  logic q_reg;

  // The original full_module logic:
  // if (L) q <= r; else q <= {q[1]^q[2], q[0], q[2]};
  // Each bit is:
  // q[2] <= L ? r[2] : (q[1] ^ q[2])
  // q[1] <= L ? r[1] : q[0]
  // q[0] <= L ? r[0] : q[2]
  // Since the submodule implementation is generic for one of these,
  // it should handle the mux logic. The previous attempt was correct.
  // Maybe the issue is the initial value?
  
  initial q_reg = 1'b0;

  always_ff @(posedge clk) begin
    if (L)
      q_reg <= r_in;
    else
      q_reg <= q_in;
  end

  assign Q = q_reg;

endmodule
