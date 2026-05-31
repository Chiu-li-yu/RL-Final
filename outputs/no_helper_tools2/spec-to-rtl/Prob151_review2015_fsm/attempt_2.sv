module TopModule(
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
        IDLE = 4'd0,
        S1 = 4'd1,
        S11 = 4'd2,
        S110 = 4'd3,
        SHIFT1 = 4'd4,
        SHIFT2 = 4'd5,
        SHIFT3 = 4'd6,
        SHIFT4 = 4'd7,
        COUNTING = 4'd8,
        DONE = 4'd9
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case (state)
            IDLE: next_state = (data) ? S1 : IDLE;
            S1:   next_state = (data) ? S11 : IDLE;
            S11:  next_state = (data) ? S11 : S110;
            S110: next_state = (data) ? SHIFT1 : IDLE;
            
            SHIFT1: begin shift_ena = 1'b1; next_state = SHIFT2; end
            SHIFT2: begin shift_ena = 1'b1; next_state = SHIFT3; end
            SHIFT3: begin shift_ena = 1'b1; next_state = SHIFT4; end
            SHIFT4: begin shift_ena = 1'b1; next_state = COUNTING; end
            
            COUNTING: begin
                counting = 1'b1;
                next_state = (done_counting) ? DONE : COUNTING;
            end
            
            DONE: begin
                done = 1'b1;
                next_state = (ack) ? IDLE : DONE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
