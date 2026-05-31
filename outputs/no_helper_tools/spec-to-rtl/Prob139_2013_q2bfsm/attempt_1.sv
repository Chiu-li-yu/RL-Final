module TopModule (
    input logic clk,
    input logic resetn,
    input logic x,
    input logic y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        STATE_A,
        STATE_F,
        STATE_WAIT_X1,
        STATE_WAIT_X0,
        STATE_WAIT_X1_FINAL,
        STATE_G,
        STATE_G_MONITOR1,
        STATE_G_MONITOR2,
        STATE_G_PERMANENT,
        STATE_G_ZERO
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn)
            state <= STATE_A;
        else
            state <= next_state;
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
                next_state = STATE_WAIT_X1;
            end
            STATE_WAIT_X1: begin
                if (x) next_state = STATE_WAIT_X0;
            end
            STATE_WAIT_X0: begin
                if (!x) next_state = STATE_WAIT_X1_FINAL;
                else next_state = STATE_WAIT_X1;
            end
            STATE_WAIT_X1_FINAL: begin
                if (x) next_state = STATE_G;
                else next_state = STATE_WAIT_X1;
            end
            STATE_G: begin
                g = 1;
                if (y) next_state = STATE_G_PERMANENT;
                else next_state = STATE_G_MONITOR1;
            end
            STATE_G_MONITOR1: begin
                g = 1;
                if (y) next_state = STATE_G_PERMANENT;
                else next_state = STATE_G_MONITOR2;
            end
            STATE_G_MONITOR2: begin
                g = 1;
                if (y) next_state = STATE_G_PERMANENT;
                else next_state = STATE_G_ZERO;
            end
            STATE_G_PERMANENT: begin
                g = 1;
            end
            STATE_G_ZERO: begin
                g = 0;
            end
        endcase
    end
endmodule
