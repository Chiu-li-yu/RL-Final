module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output logic z
);

  // States
  localparam IDLE = 2'd0, COUNTING = 2'd1, EVAL = 2'd2;
  logic [1:0] state, next_state;
  logic [1:0] w_count; // Number of w=1
  logic [1:0] cycle_count; // Tracks 3 cycles

  always_ff @(posedge clk) begin
    if (reset) state <= IDLE;
    else state <= next_state;
  end

  always @(*) begin
    next_state = state;
    case (state)
      IDLE: if (s) next_state = COUNTING;
      COUNTING: if (cycle_count == 2'd2) next_state = EVAL;
      EVAL: next_state = COUNTING;
      default: next_state = IDLE;
    endcase
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      w_count <= 2'd0;
      cycle_count <= 2'd0;
      z <= 1'b0;
    end else begin
      case (next_state)
        COUNTING: begin
          if (state == IDLE) begin
            w_count <= (w ? 2'd1 : 2'd0);
            cycle_count <= 2'd0;
            z <= 1'b0;
          end else if (state == COUNTING) begin
            w_count <= w_count + (w ? 2'd1 : 2'd0);
            cycle_count <= cycle_count + 2'd1;
          end else if (state == EVAL) begin
            w_count <= (w ? 2'd1 : 2'd0);
            cycle_count <= 2'd0;
          end
        end
        EVAL: begin
          w_count <= w_count + (w ? 2'd1 : 2'd0);
          z <= (w_count + (w ? 1'b1 : 1'b0) == 2'd2);
        end
        default: begin
          w_count <= 2'd0;
          cycle_count <= 2'd0;
          z <= 1'b0;
        end
      endcase
    end
  end

endmodule