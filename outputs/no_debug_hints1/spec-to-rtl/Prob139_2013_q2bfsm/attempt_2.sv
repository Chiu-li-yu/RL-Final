module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);
    typedef enum logic [3:0] {
        S_A, S_INIT, S_W1, S_W10, S_W101, S_G_MON, S_G_PERM, S_G_OFF
    } state_t;

    state_t state, next_state;
    logic [1:0] y_timer;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= S_A;
            y_timer <= 0;
        end else begin
            state <= next_state;
            if (state == S_G_MON) y_timer <= y_timer + 1;
            else y_timer <= 0;
        end
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;
        case (state)
            S_A: next_state = S_INIT;
            S_INIT: begin
                f = 1;
                next_state = S_W1;
            end
            S_W1: begin
                if (x) next_state = S_W10;
            end
            S_W10: begin
                if (!x) next_state = S_W101;
                else next_state = S_W10;
            end
            S_W101: begin
                if (x) begin
                    g = 1;
                    next_state = S_G_MON;
                end else begin
                    next_state = S_W1;
                end
            end
            S_G_MON: begin
                g = 1;
                if (y) next_state = S_G_PERM;
                else if (y_timer == 1) next_state = S_G_OFF;
            end
            S_G_PERM: begin
                g = 1;
            end
            S_G_OFF: begin
                g = 0;
            end
        endcase
    end
endmodule
