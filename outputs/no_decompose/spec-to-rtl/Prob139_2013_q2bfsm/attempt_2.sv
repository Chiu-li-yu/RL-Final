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
        STATE_START,
        STATE_X1,
        STATE_X10,
        STATE_X101,
        STATE_G1,
        STATE_G1_PERM,
        STATE_G0_PERM
    } state_t;

    state_t state, next_state;
    logic [1:0] y_timer;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            y_timer <= 0;
        end else begin
            state <= next_state;
            if (state == STATE_G1) y_timer <= 0;
            else if (state == STATE_G1_PERM || state == STATE_G0_PERM) y_timer <= y_timer;
            else if (state == STATE_G1_WAIT_LOOP) y_timer <= y_timer + 1;
        end
    end

    // Refined logic for state machine
    // Re-evaluating: "When x has produced 1, 0, 1 ... g set to 1 on the following cycle"
    // "While maintaining g=1 ... If y has value 1 within at most two cycles"
    
    // Let's rewrite the FSM logic more carefully.
    localparam STATE_INIT = 4'd0;
    localparam STATE_RESET_DONE = 4'd1;
    localparam STATE_X_1 = 4'd2;
    localparam STATE_X_10 = 4'd3;
    localparam STATE_X_101 = 4'd4;
    localparam STATE_G_1 = 4'd5;
    localparam STATE_G_PERM_1 = 4'd6;
    localparam STATE_G_PERM_0 = 4'd7;
    localparam STATE_WAIT_Y = 4'd8;

    logic [3:0] current_state, next_s;
    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (!resetn) current_state <= STATE_INIT;
        else current_state <= next_s;
    end

    always_ff @(posedge clk) begin
        if (!resetn) counter <= 0;
        else if (current_state == STATE_G_1) counter <= 0;
        else if (current_state == STATE_WAIT_Y) counter <= counter + 1;
    end

    always_comb begin
        next_s = current_state;
        f = 0;
        g = 0;
        case (current_state)
            STATE_INIT: next_s = STATE_RESET_DONE;
            STATE_RESET_DONE: begin
                f = 1;
                next_s = STATE_X_1;
            end
            STATE_X_1: if (x) next_s = STATE_X_10;
            STATE_X_10: if (!x) next_s = STATE_X_101; else if (x) next_s = STATE_X_1;
            STATE_X_101: if (x) next_s = STATE_G_1; else next_s = STATE_X_1;
            STATE_G_1: begin
                g = 1;
                next_s = STATE_WAIT_Y;
            end
            STATE_WAIT_Y: begin
                g = 1;
                if (y) next_s = STATE_G_PERM_1;
                else if (counter == 2'd1) next_s = STATE_G_PERM_0;
            end
            STATE_G_PERM_1: g = 1;
            STATE_G_PERM_0: g = 0;
        endcase
    end

endmodule
