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
        S_IDLE        = 4'd0,
        S_S1          = 4'd1,
        S_S11         = 4'd2,
        S_S110        = 4'd3,
        S_SHIFT_0     = 4'd4,
        S_SHIFT_1     = 4'd5,
        S_SHIFT_2     = 4'd6,
        S_SHIFT_3     = 4'd7,
        S_WAIT_COUNT  = 4'd8,
        S_DONE        = 4'd9
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            S_IDLE:       next_state = (data) ? S_S1 : S_IDLE;
            S_S1:         next_state = (data) ? S_S11 : S_IDLE;
            S_S11:        next_state = (data) ? S_S11 : S_S110;
            S_S110:       next_state = (data) ? S_SHIFT_0 : S_IDLE;
            S_SHIFT_0:    next_state = S_SHIFT_1;
            S_SHIFT_1:    next_state = S_SHIFT_2;
            S_SHIFT_2:    next_state = S_SHIFT_3;
            S_SHIFT_3:    next_state = S_WAIT_COUNT;
            S_WAIT_COUNT: next_state = (done_counting) ? S_DONE : S_WAIT_COUNT;
            S_DONE:       next_state = (ack) ? S_IDLE : S_DONE;
            default:      next_state = S_IDLE;
        endcase
    end

    always_comb begin
        if (state == S_SHIFT_0 || state == S_SHIFT_1 || state == S_SHIFT_2 || state == S_SHIFT_3)
            shift_ena = 1'b1;
        else
            shift_ena = 1'b0;

        if (state == S_WAIT_COUNT)
            counting = 1'b1;
        else
            counting = 1'b0;

        if (state == S_DONE)
            done = 1'b1;
        else
            done = 1'b0;
    end

endmodule
