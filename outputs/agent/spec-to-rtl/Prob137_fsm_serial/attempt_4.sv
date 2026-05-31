module TopModule (
    input logic clk,
    input logic reset,
    input logic in,
    output logic done
);

    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA0, DATA1, DATA2, DATA3, DATA4, DATA5, DATA6, DATA7,
        STOP
    } state_t;

    state_t state, next_state;
    logic done_r;

    always_ff @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = DATA0;
            DATA0: next_state = DATA1;
            DATA1: next_state = DATA2;
            DATA2: next_state = DATA3;
            DATA3: next_state = DATA4;
            DATA4: next_state = DATA5;
            DATA5: next_state = DATA6;
            DATA6: next_state = DATA7;
            DATA7: next_state = STOP;
            STOP: next_state = (in == 1'b1) ? IDLE : STOP; // Wait in STOP if bit is 0
            default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) done_r <= 1'b0;
        else if (state == STOP && in == 1'b1) done_r <= 1'b1;
        else done_r <= 1'b0;
    end

    assign done = done_r;

endmodule