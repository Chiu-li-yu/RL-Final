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
        STATE_F,
        STATE_WAIT_X1,
        STATE_WAIT_X0,
        STATE_WAIT_X1_FINAL,
        STATE_CHECK_Y,
        STATE_CHECK_Y1,
        STATE_PERMANENT_G,
        STATE_PERMANENT_NO_G
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        f = 0;
        g = 0;
        next_state = state;

        case (state)
            STATE_A: next_state = STATE_F;
            
            STATE_F: begin
                f = 1;
                next_state = STATE_WAIT_X1;
            end

            STATE_WAIT_X1: begin
                if (x) next_state = STATE_WAIT_X0;
                else next_state = STATE_WAIT_X1;
            end

            STATE_WAIT_X0: begin
                if (!x) next_state = STATE_WAIT_X1_FINAL;
                else next_state = STATE_WAIT_X1; // Reset sequence if x=1, stay in wait_x1
            end

            STATE_WAIT_X1_FINAL: begin
                if (x) next_state = STATE_CHECK_Y;
                else next_state = STATE_WAIT_X1;
            end

            STATE_CHECK_Y: begin
                g = 1;
                if (y) next_state = STATE_PERMANENT_G;
                else next_state = STATE_CHECK_Y1;
            end

            STATE_CHECK_Y1: begin
                g = 1;
                if (y) next_state = STATE_PERMANENT_G;
                else next_state = STATE_PERMANENT_NO_G;
            end

            STATE_PERMANENT_G: begin
                g = 1;
                next_state = STATE_PERMANENT_G;
            end

            STATE_PERMANENT_NO_G: begin
                g = 0;
                next_state = STATE_PERMANENT_NO_G;
            end
        endcase
    end
endmodule
