module TopModule(
    input clk,
    input reset,
    input in,
    output logic done
);

    typedef enum logic [3:0] {
        IDLE,
        START,
        DATA_0, DATA_1, DATA_2, DATA_3, DATA_4, DATA_5, DATA_6, DATA_7,
        STOP,
        WAIT_FOR_IDLE
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end
            START: next_state = DATA_0;
            DATA_0: next_state = DATA_1;
            DATA_1: next_state = DATA_2;
            DATA_2: next_state = DATA_3;
            DATA_3: next_state = DATA_4;
            DATA_4: next_state = DATA_5;
            DATA_5: next_state = DATA_6;
            DATA_6: next_state = DATA_7;
            DATA_7: begin
                if (in == 1'b1)
                    next_state = STOP;
                else
                    next_state = WAIT_FOR_IDLE;
            end
            STOP: begin
                done = 1'b1;
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            WAIT_FOR_IDLE: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
