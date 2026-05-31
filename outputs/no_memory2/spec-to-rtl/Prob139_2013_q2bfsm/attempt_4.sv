module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        STATE_A, STATE_B, 
        SEQ_1, SEQ_10, SEQ_101, 
        STATE_C, 
        Y_CHECK_1, Y_CHECK_2, 
        G_PERM_1, G_PERM_0
    } state_t;

    logic [3:0] state, next_state;
    logic [1:0] y_timer;

    always_ff @(posedge clk) begin
        if (!resetn) state <= STATE_A;
        else state <= next_state;
    end

    always_ff @(posedge clk) begin
        if (!resetn) y_timer <= 0;
        else if (state == STATE_C) y_timer <= 0;
        else if (state == Y_CHECK_1 || state == Y_CHECK_2) y_timer <= y_timer + 1;
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            STATE_A: next_state = STATE_B;
            STATE_B: begin
                f = 1;
                next_state = SEQ_1;
            end
            SEQ_1: begin
                if (x) next_state = SEQ_10;
                else next_state = SEQ_1;
            end
            SEQ_10: begin
                if (!x) next_state = SEQ_101;
                else next_state = SEQ_1;
            end
            SEQ_101: begin
                if (x) next_state = STATE_C;
                else next_state = SEQ_1;
            end
            STATE_C: begin
                g = 1;
                next_state = Y_CHECK_1;
            end
            Y_CHECK_1: begin
                g = 1;
                if (y) next_state = G_PERM_1;
                else next_state = Y_CHECK_2;
            end
            Y_CHECK_2: begin
                g = 1;
                if (y) next_state = G_PERM_1;
                else next_state = G_PERM_0;
            end
            G_PERM_1: begin
                g = 1;
                next_state = G_PERM_1;
            end
            G_PERM_0: begin
                g = 0;
                next_state = G_PERM_0;
            end
            default: next_state = STATE_A;
        endcase
    end
endmodule
