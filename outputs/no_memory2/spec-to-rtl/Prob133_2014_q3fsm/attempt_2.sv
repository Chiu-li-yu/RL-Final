module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum logic [2:0] {
        STATE_A = 3'b000,
        STATE_CHECK_1 = 3'b001,
        STATE_CHECK_2 = 3'b010,
        STATE_CHECK_3 = 3'b011,
        STATE_RESULT = 3'b100
    } state_t;

    logic [2:0] state, next_state;
    logic [1:0] w_count, next_w_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            w_count <= 2'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= next_w_count;
            
            if (state == STATE_RESULT)
                z <= (w_count == 2'd2);
            else
                z <= 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        next_w_count = w_count;

        case (state)
            STATE_A: begin
                if (s) next_state = STATE_CHECK_1;
            end
            STATE_CHECK_1: begin
                next_w_count = w ? 2'd1 : 2'd0;
                next_state = STATE_CHECK_2;
            end
            STATE_CHECK_2: begin
                next_w_count = w_count + (w ? 1'b1 : 1'b0);
                next_state = STATE_CHECK_3;
            end
            STATE_CHECK_3: begin
                next_w_count = w_count + (w ? 1'b1 : 1'b0);
                next_state = STATE_RESULT;
            end
            STATE_RESULT: begin
                next_w_count = 2'd0;
                next_state = STATE_CHECK_1;
            end
            default: next_state = STATE_A;
        endcase
    end
endmodule