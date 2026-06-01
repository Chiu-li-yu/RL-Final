module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output logic shift_ena,
    output logic counting,
    output logic done
);

    typedef enum logic [3:0] {
        IDLE, S1, S11, S110,
        SHIFT,
        WAIT_COUNT,
        DONE
    } state_t;

    state_t state, next_state;
    logic [2:0] shift_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (data) next_state = S1;
            end
            S1: begin
                if (data) next_state = S11;
                else next_state = IDLE;
            end
            S11: begin
                if (!data) next_state = S110;
                else next_state = S11;
            end
            S110: begin
                if (data) next_state = SHIFT;
                else next_state = IDLE;
            end
            SHIFT: begin
                if (shift_cnt == 3'd3) next_state = WAIT_COUNT;
            end
            WAIT_COUNT: begin
                if (done_counting) next_state = DONE;
            end
            DONE: begin
                if (ack) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            shift_cnt <= 3'd0;
        end else begin
            if (state == SHIFT) shift_cnt <= shift_cnt + 1'b1;
            else shift_cnt <= 3'd0;
        end
    end

    always @(*) begin
        shift_ena = (state == SHIFT);
        counting = (state == WAIT_COUNT);
        done = (state == DONE);
    end
endmodule
