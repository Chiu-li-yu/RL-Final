module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);
    localparam A = 2'd0, B = 2'd1, C = 2'd2;
    logic [1:0] state, next_state;
    logic [1:0] cycle_cnt, next_cycle_cnt;
    logic [1:0] w_cnt, next_w_cnt;

    always @(*) begin
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_cnt = w_cnt;

        case (state)
            A: begin
                if (s) begin
                    next_state = B;
                    next_cycle_cnt = 2'd0;
                    next_w_cnt = 2'd0;
                end else begin
                    next_state = A;
                    next_cycle_cnt = 2'd0;
                    next_w_cnt = 2'd0;
                end
            end
            B: begin
                if (cycle_cnt == 2'd2) begin
                    next_state = C;
                    next_cycle_cnt = 2'd0;
                    next_w_cnt = w_cnt + (w ? 2'd1 : 2'd0);
                end else begin
                    next_state = B;
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_cnt = w_cnt + (w ? 2'd1 : 2'd0);
                end
            end
            C: begin
                next_state = B;
                next_cycle_cnt = 2'd0;
                next_w_cnt = 2'd0;
            end
            default: begin
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_cnt = 2'd0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_cnt <= 2'd0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_cnt <= next_w_cnt;
        end
    end

    assign z = (state == C && w_cnt == 2'd2);

endmodule
