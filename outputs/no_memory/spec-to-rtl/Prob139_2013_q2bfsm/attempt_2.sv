module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);
    // States
    parameter S_IDLE = 3'd0;
    parameter S_F_PULSE = 3'd1;
    parameter S_WAIT_X = 3'd2;
    parameter S_CHECK_Y = 3'd3;
    parameter S_G_HIGH = 3'd4;
    parameter S_G_LOW = 3'd5;

    logic [2:0] state, next_state;
    logic [1:0] x_seq; // tracks 1, 0, 1
    logic [1:0] y_timer;
    logic f_reg, g_reg;

    always @(posedge clk) begin
        if (!resetn) state <= S_IDLE;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: next_state = S_F_PULSE;
            S_F_PULSE: next_state = S_WAIT_X;
            S_WAIT_X: begin
                if (x_seq == 2'b11 && x == 1'b1) next_state = S_CHECK_Y;
            end
            S_CHECK_Y: begin
                if (y == 1'b1) next_state = S_G_HIGH;
                else if (y_timer == 2'd2) next_state = S_G_LOW;
            end
            S_G_HIGH, S_G_LOW: next_state = state;
            default: next_state = S_IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (!resetn) begin
            x_seq <= 2'b00;
            y_timer <= 2'd0;
            f_reg <= 1'b0;
            g_reg <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    f_reg <= 1'b0;
                    g_reg <= 1'b0;
                    x_seq <= 2'b00;
                end
                S_F_PULSE: f_reg <= 1'b1;
                S_WAIT_X: begin
                    f_reg <= 1'b0;
                    if (x_seq == 2'b00 && x == 1'b1) x_seq <= 2'b01;
                    else if (x_seq == 2'b01 && x == 1'b0) x_seq <= 2'b10;
                    else if (x_seq == 2'b10 && x == 1'b1) x_seq <= 2'b11;
                    else if (x == 1'b0) x_seq <= 2'b00;
                end
                S_CHECK_Y: begin
                    g_reg <= 1'b1;
                    if (y == 1'b1) g_reg <= 1'b1;
                    else y_timer <= y_timer + 1'b1;
                end
                S_G_HIGH: g_reg <= 1'b1;
                S_G_LOW: g_reg <= 1'b0;
            endcase
        end
    end

    assign f = f_reg;
    assign g = g_reg;
endmodule
