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
        STATE_X_1,
        STATE_X_10,
        STATE_X_101,
        STATE_MONITOR_Y1,
        STATE_MONITOR_Y2,
        STATE_G_HIGH,
        STATE_G_LOW
    } state_t;

    logic [3:0] state, next_state;
    logic f_reg, g_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            f_reg <= 0;
            g_reg <= 0;
        end else begin
            state <= next_state;
            if (state == STATE_A) f_reg <= 1;
            else f_reg <= 0;
            
            if (state == STATE_X_101) g_reg <= 1;
            else if (state == STATE_MONITOR_Y2 && y == 0) g_reg <= 0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            STATE_A: next_state = STATE_F;
            STATE_F: next_state = (x == 1) ? STATE_X_1 : STATE_F;
            STATE_X_1: next_state = (x == 0) ? STATE_X_10 : (x == 1 ? STATE_X_1 : STATE_F);
            STATE_X_10: next_state = (x == 1) ? STATE_X_101 : (x == 0 ? STATE_F : STATE_X_10);
            STATE_X_101: next_state = STATE_MONITOR_Y1;
            STATE_MONITOR_Y1: next_state = (y == 1) ? STATE_G_HIGH : STATE_MONITOR_Y2;
            STATE_MONITOR_Y2: next_state = (y == 1) ? STATE_G_HIGH : STATE_G_LOW;
            STATE_G_HIGH: next_state = STATE_G_HIGH;
            STATE_G_LOW: next_state = STATE_G_LOW;
            default: next_state = STATE_A;
        endcase
    end

    assign f = f_reg;
    assign g = g_reg;

endmodule
