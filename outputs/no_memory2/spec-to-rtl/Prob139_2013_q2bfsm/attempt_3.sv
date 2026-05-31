module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        STATE_A = 4'd0,
        STATE_F = 4'd1,
        STATE_WAIT_1 = 4'd2,
        STATE_WAIT_0 = 4'd3,
        STATE_WAIT_1_FINAL = 4'd4,
        STATE_G_HIGH = 4'd5,
        STATE_CHECK_Y1 = 4'd6,
        STATE_CHECK_Y2 = 4'd7,
        STATE_G_PERM = 4'd8,
        STATE_G_OFF = 4'd9
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            STATE_A: begin
                next_state = STATE_F;
            end
            STATE_F: begin
                f = 1;
                next_state = STATE_WAIT_1;
            end
            STATE_WAIT_1: begin
                if (x) next_state = STATE_WAIT_0;
                else next_state = STATE_WAIT_1;
            end
            STATE_WAIT_0: begin
                if (!x) next_state = STATE_WAIT_1_FINAL;
                else if (x) next_state = STATE_WAIT_0;
            end
            STATE_WAIT_1_FINAL: begin
                if (x) next_state = STATE_G_HIGH;
                else next_state = STATE_WAIT_1;
            end
            STATE_G_HIGH: begin
                g = 1;
                next_state = STATE_CHECK_Y1;
            end
            STATE_CHECK_Y1: begin
                g = 1;
                if (y) next_state = STATE_G_PERM;
                else next_state = STATE_CHECK_Y2;
            end
            STATE_CHECK_Y2: begin
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
        endcase
    end
endmodule
