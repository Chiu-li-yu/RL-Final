module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        STATE_A,
        STATE_F1,
        STATE_IDLE,
        STATE_X1,
        STATE_X10,
        STATE_G1,
        STATE_Y_WAIT1,
        STATE_Y_WAIT2,
        STATE_G_PERM,
        STATE_G_OFF
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (!resetn)
            state <= STATE_A;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            STATE_A: next_state = STATE_F1;
            STATE_F1: begin
                f = 1;
                next_state = STATE_IDLE;
            end
            STATE_IDLE: begin
                if (x) next_state = STATE_X1;
            end
            STATE_X1: begin
                if (x) next_state = STATE_X1;
                else next_state = STATE_X10;
            end
            STATE_X10: begin
                if (x) next_state = STATE_G1;
                else next_state = STATE_IDLE;
            end
            STATE_G1: begin
                g = 1;
                if (y) next_state = STATE_G_PERM;
                else next_state = STATE_Y_WAIT1;
            end
            STATE_Y_WAIT1: begin
                g = 1;
                if (y) next_state = STATE_G_PERM;
                else next_state = STATE_Y_WAIT2;
            end
            STATE_Y_WAIT2: begin
                g = 1;
                if (y) next_state = STATE_G_PERM;
                else next_state = STATE_G_OFF;
            end
            STATE_G_PERM: begin
                g = 1;
            end
            STATE_G_OFF: begin
                g = 0;
            end
            default: next_state = STATE_A;
        endcase
    end
endmodule
