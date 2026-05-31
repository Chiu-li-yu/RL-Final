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
        IDLE = 4'd0,
        S1 = 4'd1,
        S11 = 4'd2,
        S110 = 4'd3,
        SHIFT = 4'd4,
        WAIT_COUNT = 4'd5,
        DONE_STATE = 4'd6
    } state_t;

    state_t state, next_state;
    logic [2:0] shift_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                shift_count <= (shift_count == 3'd3) ? 3'd0 : shift_count + 3'd1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    always_comb begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: next_state = (data) ? S1 : IDLE;
            S1:   next_state = (data) ? S11 : IDLE;
            S11:  next_state = (!data) ? S110 : S11;
            S110: next_state = (data) ? SHIFT : IDLE;
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd3) next_state = WAIT_COUNT;
            end
            WAIT_COUNT: begin
                counting = 1'b1;
                if (done_counting) next_state = DONE_STATE;
            end
            DONE_STATE: begin
                done = 1'b1;
                if (ack) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule