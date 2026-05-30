module TopModule (
    input logic clk,
    input logic reset,
    input logic s,
    input logic w,
    output logic z
);
    typedef enum logic {
        STATE_A = 1'b0,
        STATE_B = 1'b1
    } state_t;

    state_t state, next_state;
    logic [1:0] cycle_cnt;
    logic [1:0] w_ones_cnt;
    logic z_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            cycle_cnt <= 2'd0;
            w_ones_cnt <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            
            if (state == STATE_B) begin
                if (cycle_cnt == 2'd2) begin
                    cycle_cnt <= 2'd0;
                    w_ones_cnt <= 2'd0;
                    z <= (w_ones_cnt + w == 2'd2);
                end else begin
                    cycle_cnt <= cycle_cnt + 2'd1;
                    w_ones_cnt <= w_ones_cnt + (w ? 2'd1 : 2'd0);
                    z <= 1'b0;
                end
            end else begin
                cycle_cnt <= 2'd0;
                w_ones_cnt <= 2'd0;
                z <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            STATE_A: begin
                if (s) next_state = STATE_B;
            end
            STATE_B: begin
                next_state = STATE_B;
            end
        endcase
    end
endmodule