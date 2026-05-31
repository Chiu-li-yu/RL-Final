module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        STATE_A,    // Reset state
        STATE_INIT, // f=1
        STATE_WAIT, // Monitoring x=1,0,1
        STATE_X1,
        STATE_X10,
        STATE_X101, // G=1 triggered
        STATE_G_MONITOR, // Monitoring y
        STATE_G_PERM,
        STATE_G_OFF
    } state_t;

    state_t state, next_state;
    logic [1:0] y_count;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            y_count <= 0;
        end else begin
            state <= next_state;
            if (state == STATE_X101) y_count <= 0;
            else if (state == STATE_G_MONITOR) y_count <= y_count + 1;
        end
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            STATE_A: next_state = STATE_INIT;
            STATE_INIT: begin
                f = 1;
                next_state = STATE_WAIT;
            end
            STATE_WAIT: begin
                if (x) next_state = STATE_X1;
            end
            STATE_X1: begin
                if (!x) next_state = STATE_X10;
                else next_state = STATE_X1;
            end
            STATE_X10: begin
                if (x) next_state = STATE_X101;
                else next_state = STATE_WAIT;
            end
            STATE_X101: begin
                g = 1;
                next_state = STATE_G_MONITOR;
            end
            STATE_G_MONITOR: begin
                g = 1;
                if (y) next_state = STATE_G_PERM;
                else if (y_count == 2) next_state = STATE_G_OFF;
            end
            STATE_G_PERM: begin
                g = 1;
            end
            STATE_G_OFF: begin
                g = 0;
            end
        endcase
    end
endmodule
