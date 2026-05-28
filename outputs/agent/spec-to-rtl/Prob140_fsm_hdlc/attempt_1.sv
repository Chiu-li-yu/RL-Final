module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // States represent the number of consecutive 1s received.
  // S0: 0 ones, S1: 1, S2: 2, S3: 3, S4: 4, S5: 5
  // S6_FLAG: 6 ones followed by 0 (flag sequence 01111110)
  // S5_DISC: 5 ones followed by 0 (discard sequence 0111110)
  // S7_ERR: 7 or more ones
  localparam S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5;
  localparam S6 = 4'd6;
  localparam S7_ERR = 4'd7;
  localparam S5_DISC_WAIT = 4'd8; // After receiving 011111, if next is 0
  localparam S6_FLAG_WAIT = 4'd9; // After receiving 0111111, if next is 0

  logic [3:0] state, next_state;
  logic disc_r, flag_r, err_r;

  always_ff @(posedge clk) begin
    if (reset) begin
      state <= S0;
      disc_r <= 1'b0;
      flag_r <= 1'b0;
      err_r <= 1'b0;
    end else begin
      state <= next_state;
      disc_r <= (next_state == S5_DISC_WAIT);
      flag_r <= (next_state == S6_FLAG_WAIT);
      err_r <= (next_state == S7_ERR);
    end
  end

  assign disc = disc_r;
  assign flag = flag_r;
  assign err = err_r;

  always @(*) begin
    next_state = state;
    case (state)
      S0: next_state = in ? S1 : S0;
      S1: next_state = in ? S2 : S0;
      S2: next_state = in ? S3 : S0;
      S3: next_state = in ? S4 : S0;
      S4: next_state = in ? S5 : S0;
      S5: next_state = in ? S6 : S5_DISC_WAIT;
      S6: next_state = in ? S7_ERR : S6_FLAG_WAIT;
      S7_ERR: next_state = in ? S7_ERR : S0;
      S5_DISC_WAIT: next_state = in ? S1 : S0;
      S6_FLAG_WAIT: next_state = in ? S1 : S0;
      default: next_state = S0;
    endcase
  end

endmodule
