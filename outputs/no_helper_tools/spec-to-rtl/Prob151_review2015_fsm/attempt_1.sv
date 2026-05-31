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
        IDLE,
        S1,
        S11,
        S110,
        SHIFTING,
        WAITING,
        DONE
    } state_t;

    state_t state, next_state;
    logic [2:0] shift_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            if (state == SHIFTING)
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 3'd0;
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
            S110: next_state = (data) ? SHIFTING : IDLE;
            
            SHIFTING: begin
                shift_ena = 1;
                if (shift_count == 3'd3)
                    next_state = WAITING;
            end
            
            WAITING: begin
                counting = 1;
                if (done_counting)
                    next_state = DONE;
            end
            
            DONE: begin
                done = 1;
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

endmodule
