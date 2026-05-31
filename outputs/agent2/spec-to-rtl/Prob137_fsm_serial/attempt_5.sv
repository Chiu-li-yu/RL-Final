module TopModule (
    input logic clk,
    input logic reset,
    input logic in,
    output logic done
);

    typedef enum logic [3:0] {
        IDLE,
        START,
        D0, D1, D2, D3, D4, D5, D6, D7,
        STOP,
        WAIT
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:  next_state = (in == 0) ? START : IDLE;
            START: next_state = D0;
            D0:    next_state = D1;
            D1:    next_state = D2;
            D2:    next_state = D3;
            D3:    next_state = D4;
            D4:    next_state = D5;
            D5:    next_state = D6;
            D6:    next_state = D7;
            D7:    next_state = STOP;
            STOP:  next_state = (in == 1) ? IDLE : WAIT;
            WAIT:  next_state = (in == 1) ? IDLE : WAIT;
            default: next_state = IDLE;
        endcase
    end

    assign done = (state == STOP && in == 1);

endmodule