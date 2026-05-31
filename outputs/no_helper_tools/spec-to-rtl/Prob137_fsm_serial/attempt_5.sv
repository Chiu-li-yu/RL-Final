module TopModule (
    input logic clk,
    input logic reset,
    input logic in,
    output logic done
);

    typedef enum logic [3:0] {
        IDLE,
        START,
        BIT0, BIT1, BIT2, BIT3, BIT4, BIT5, BIT6, BIT7,
        STOP,
        WAIT
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
            IDLE:
                if (in == 1'b0) next_state = START;
                else next_state = IDLE;
            START: next_state = BIT0;
            BIT0: next_state = BIT1;
            BIT1: next_state = BIT2;
            BIT2: next_state = BIT3;
            BIT3: next_state = BIT4;
            BIT4: next_state = BIT5;
            BIT5: next_state = BIT6;
            BIT6: next_state = BIT7;
            BIT7: next_state = STOP;
            STOP:
                if (in == 1'b1) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = WAIT;
                end
            WAIT:
                if (in == 1'b1) next_state = IDLE;
                else next_state = WAIT;
            default: next_state = IDLE;
        endcase
    end
endmodule
