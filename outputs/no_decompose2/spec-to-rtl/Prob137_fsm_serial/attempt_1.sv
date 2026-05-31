module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    typedef enum logic [3:0] {
        IDLE    = 4'd0,
        START   = 4'd1,
        DATA0   = 4'd2,
        DATA1   = 4'd3,
        DATA2   = 4'd4,
        DATA3   = 4'd5,
        DATA4   = 4'd6,
        DATA5   = 4'd7,
        DATA6   = 4'd8,
        DATA7   = 4'd9,
        STOP    = 4'd10,
        DONE    = 4'd11,
        WAIT    = 4'd12
    } state_t;

    logic [3:0] state, next_state;
    logic done_q;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_q <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == DONE)
                done_q <= 1'b1;
            else
                done_q <= 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:  next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = DATA0;
            DATA0: next_state = DATA1;
            DATA1: next_state = DATA2;
            DATA2: next_state = DATA3;
            DATA3: next_state = DATA4;
            DATA4: next_state = DATA5;
            DATA5: next_state = DATA6;
            DATA6: next_state = DATA7;
            DATA7: next_state = STOP;
            STOP:  next_state = (in == 1'b1) ? DONE : WAIT;
            DONE:  next_state = (in == 1'b0) ? START : IDLE;
            WAIT:  next_state = (in == 1'b1) ? IDLE : WAIT;
            default: next_state = IDLE;
        endcase
    end

    assign done = (state == DONE);

endmodule
