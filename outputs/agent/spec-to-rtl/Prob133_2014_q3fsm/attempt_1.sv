module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  localparam A = 3'd0, B = 3'd1, C = 3'd2, D = 3'd3, E = 3'd4, DONE = 3'd5;
  logic [2:0] state, next_state;
  logic [1:0] count; 

  always_ff @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
  end

  always @(*) begin
    next_state = state;
    case (state)
      A: if (s) next_state = B; else next_state = A;
      B: next_state = C;
      C: next_state = D;
      D: next_state = E;
      E: next_state = B;
      default: next_state = A;
    endcase
  end

  logic [1:0] w_count;
  always_ff @(posedge clk) begin
    if (reset) begin
        w_count <= 2'd0;
        z <= 1'b0;
        count <= 2'd0;
    end else begin
        case (state)
            B: begin
                w_count <= (w ? 2'd1 : 2'd0);
                z <= 1'b0;
                count <= 2'd1;
            end
            C: begin
                w_count <= w_count + (w ? 2'd1 : 2'd0);
                count <= 2'd2;
            end
            D: begin
                w_count <= w_count + (w ? 2'd1 : 2'd0);
                count <= 2'd3;
            end
            E: begin
                z <= (w_count == 2'd2);
                w_count <= 2'd0;
                count <= 2'd0;
            end
            default: begin
                z <= 1'b0;
            end
        endcase
    end
  end

endmodule