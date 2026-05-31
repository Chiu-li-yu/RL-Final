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
        IDLE, S1, S11, S110, SHIFT, WAIT_COUNT, DONE_STATE
    } state_t;

    state_t state, next_state;
    logic [2:0] shift_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 0;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 1;
            else
                shift_count <= 0;
        end
    end

    always @(*) begin
        next_state = state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (state)
            IDLE: next_state = (data) ? S1 : IDLE;
            S1:   next_state = (data) ? S11 : IDLE;
            S11:  next_state = (data) ? S11 : S110;
            S110: next_state = (data) ? SHIFT : IDLE;
            SHIFT: begin
                shift_ena = 1;
                next_state = (shift_count == 3) ? WAIT_COUNT : SHIFT;
            end
            WAIT_COUNT: begin
                counting = 1;
                next_state = (done_counting) ? DONE_STATE : WAIT_COUNT;
            end
            DONE_STATE: begin
                done = 1;
                next_state = (ack) ? IDLE : DONE_STATE;
            end
        endcase
    end
endmodule
