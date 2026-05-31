module TopModule(
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    typedef enum logic [3:0] {
        S_IDLE, S_BIT1, S_BIT11, S_BIT110, S_SHIFT, S_COUNT, S_DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] delay;
    logic [2:0] shift_count;
    logic [15:0] cycle_counter; // For 1000 cycle intervals
    logic [3:0] current_val;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            delay <= 0;
            shift_count <= 0;
            cycle_counter <= 0;
            current_val <= 0;
            count <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            if (state == S_SHIFT) begin
                if (shift_count < 3) begin
                    delay <= {delay[2:0], data};
                    shift_count <= shift_count + 1;
                end else begin
                    delay <= {delay[2:0], data};
                    shift_count <= 0;
                end
            end else if (state == S_IDLE) begin
                delay <= 0;
                shift_count <= 0;
            end

            if (state == S_COUNT) begin
                if (cycle_counter == 999) begin
                    cycle_counter <= 0;
                    if (current_val > 0) current_val <= current_val - 1;
                end else begin
                    cycle_counter <= cycle_counter + 1;
                end
            end else if (state == S_SHIFT && next_state == S_COUNT) begin
                current_val <= {delay[2:0], data};
                cycle_counter <= 0;
            end

            if (state == S_COUNT) count <= current_val;
            else count <= 0;

            counting <= (state == S_COUNT);
            done <= (state == S_DONE);
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            S_IDLE: if (data) next_state = S_BIT1;
            S_BIT1: if (data) next_state = S_BIT11; else next_state = S_IDLE;
            S_BIT11: if (!data) next_state = S_BIT110; else next_state = S_BIT11;
            S_BIT110: if (data) next_state = S_SHIFT; else next_state = S_IDLE;
            S_SHIFT: if (shift_count == 3) next_state = S_COUNT;
            S_COUNT: if (current_val == 0 && cycle_counter == 999) next_state = S_DONE;
            S_DONE: if (ack) next_state = S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end
endmodule
