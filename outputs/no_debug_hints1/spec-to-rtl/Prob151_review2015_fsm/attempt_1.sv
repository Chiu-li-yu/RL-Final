module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    input logic done_counting,
    input logic ack,
    output logic shift_ena,
    output logic counting,
    output logic done
);

    typedef enum logic [3:0] {
        IDLE,
        S1,
        S11,
        S110,
        SHIFT,
        WAIT_COUNT,
        DONE_STATE
    } state_t;

    state_t state, next_state;
    logic [2:0] shift_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 0;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                shift_count <= (shift_count == 3) ? 0 : shift_count + 1;
            end else begin
                shift_count <= 0;
            end
        end
    end

    always_comb begin
        next_state = state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (state)
            IDLE: next_state = (data) ? S1 : IDLE;
            S1:   next_state = (data) ? S11 : IDLE;
            S11:  next_state = (!data) ? S110 : S11;
            S110: next_state = (data) ? SHIFT : IDLE;
            SHIFT: begin
                shift_ena = 1;
                if (shift_count == 3) next_state = WAIT_COUNT;
            end
            WAIT_COUNT: begin
                counting = 1;
                if (done_counting) next_state = DONE_STATE;
            end
            DONE_STATE: begin
                done = 1;
                if (ack) next_state = IDLE;
            end
        endcase
    end
endmodule