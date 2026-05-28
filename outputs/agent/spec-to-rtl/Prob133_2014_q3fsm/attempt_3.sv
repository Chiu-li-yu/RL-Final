module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output logic z
);

  localparam A = 2'd0, B = 2'd1, C = 2'd2, D = 2'd3;
  logic [1:0] state, next_state;
  logic [1:0] w_count;

  always_ff @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
  end

  always @(*) begin
    case (state)
      A: next_state = s ? B : A;
      B: next_state = C;
      C: next_state = D;
      D: next_state = B;
      default: next_state = A;
    endcase
  end

  always_ff @(posedge clk) begin
    if (reset) begin
        z <= 1'b0;
        w_count <= 2'd0;
    end else begin
        case (state)
            A: begin
                z <= 1'b0;
                w_count <= 2'd0;
            end
            B: begin
                w_count <= (w ? 2'd1 : 2'd0);
                z <= 1'b0;
            end
            C: begin
                w_count <= w_count + (w ? 2'd1 : 2'd0);
            end
            D: begin
                z <= ((w_count + (w ? 2'd1 : 2'd0)) == 2'd2);
                w_count <= 2'd0;
            end
        endcase
    end
  end

endmodule