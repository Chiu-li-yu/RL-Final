module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);
    typedef enum logic [3:0] {
        IDLE,
        INIT_F,
        WAIT_X1,
        WAIT_X0,
        WAIT_X1_FINAL,
        G_HIGH_CHECK_Y,
        CHECK_Y1,
        CHECK_Y2,
        G_PERM,
        G_ZERO
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (!resetn) state <= IDLE;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            IDLE: next_state = INIT_F;
            
            INIT_F: begin
                f = 1;
                next_state = WAIT_X1;
            end
            
            WAIT_X1: begin
                if (x) next_state = WAIT_X0;
            end
            
            WAIT_X0: begin
                if (x) next_state = WAIT_X0;
                else next_state = WAIT_X1_FINAL;
            end
            
            WAIT_X1_FINAL: begin
                if (x) next_state = G_HIGH_CHECK_Y;
                else next_state = WAIT_X1;
            end
            
            G_HIGH_CHECK_Y: begin
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = CHECK_Y2;
            end
            
            CHECK_Y2: begin
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = G_ZERO;
            end
            
            G_PERM: begin
                g = 1;
                next_state = G_PERM;
            end
            
            G_ZERO: begin
                g = 0;
                next_state = G_ZERO;
            end
            
            default: next_state = IDLE;
        endcase
    end
endmodule
