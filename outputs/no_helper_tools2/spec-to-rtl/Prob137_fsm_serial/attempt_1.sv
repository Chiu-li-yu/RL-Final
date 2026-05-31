module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    typedef enum logic [3:0] {
        IDLE,
        START,
        DATA0, DATA1, DATA2, DATA3, DATA4, DATA5, DATA6, DATA7,
        STOP,
        WAIT_FOR_STOP
    } state_t;

    state_t state, next_state;
    logic done_q;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_q <= 1'b0;
        end else begin
            state <= next_state;
            if (state == STOP && in == 1'b1)
                done_q <= 1'b1;
            else
                done_q <= 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:
                if (in == 1'b0)
                    next_state = START;
            START:
                next_state = DATA0;
            DATA0: next_state = DATA1;
            DATA1: next_state = DATA2;
            DATA2: next_state = DATA3;
            DATA3: next_state = DATA4;
            DATA4: next_state = DATA5;
            DATA5: next_state = DATA6;
            DATA6: next_state = DATA7;
            DATA7:
                next_state = (in == 1'b1) ? STOP : WAIT_FOR_STOP;
            STOP:
                next_state = (in == 1'b0) ? START : IDLE;
            WAIT_FOR_STOP:
                if (in == 1'b1)
                    next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    assign done = done_q;

endmodule
