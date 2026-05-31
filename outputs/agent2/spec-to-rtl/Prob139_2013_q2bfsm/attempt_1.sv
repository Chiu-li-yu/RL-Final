module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);
    typedef enum logic [3:0] {
        STATE_A,
        STATE_F,
        WAIT_X1,
        WAIT_X0,
        WAIT_X1_FINAL,
        CHECK_Y,
        CHECK_Y_1,
        G_PERM_1,
        G_PERM_0
    } state_t;

    logic [3:0] state, next_state;
    logic f_reg, g_reg;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            f_reg <= 0;
            g_reg <= 0;
        end else begin
            state <= next_state;
            if (state == STATE_F) f_reg <= 1;
            else f_reg <= 0;

            if (state == CHECK_Y || state == CHECK_Y_1 || state == G_PERM_1) g_reg <= 1;
            else g_reg <= 0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            STATE_A: next_state = STATE_F;
            STATE_F: next_state = WAIT_X1;
            WAIT_X1: next_state = x ? WAIT_X0 : WAIT_X1;
            WAIT_X0: next_state = x ? WAIT_X1 : WAIT_X1_FINAL;
            WAIT_X1_FINAL: next_state = x ? CHECK_Y : WAIT_X1;
            CHECK_Y: next_state = y ? G_PERM_1 : CHECK_Y_1;
            CHECK_Y_1: next_state = y ? G_PERM_1 : G_PERM_0;
            G_PERM_1: next_state = G_PERM_1;
            G_PERM_0: next_state = G_PERM_0;
            default: next_state = STATE_A;
        endcase
    end

    assign f = f_reg;
    assign g = g_reg;

endmodule
