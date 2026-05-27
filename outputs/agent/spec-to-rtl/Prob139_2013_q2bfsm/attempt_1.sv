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
        STATE_F_1,
        STATE_WAIT_X1,
        STATE_X1,
        STATE_X10,
        STATE_X101,
        STATE_MONITOR_Y_1,
        STATE_MONITOR_Y_2,
        STATE_G_PERM,
        STATE_G_OFF
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
                next_state = STATE_F_1;
            end

            STATE_F_1: begin
                f = 1;
                next_state = STATE_WAIT_X1;
            end

            STATE_WAIT_X1: begin
                if (x) next_state = STATE_X1;
            end

            STATE_X1: begin
                if (!x) next_state = STATE_X10;
                else next_state = STATE_X1;
            end

            STATE_X10: begin
                if (x) next_state = STATE_X101;
                else next_state = STATE_WAIT_X1;
            end

            STATE_X101: begin
                g = 1;
                next_state = STATE_MONITOR_Y_1;
            end

            STATE_MONITOR_Y_1: begin
                g = 1;
                if (y) next_state = STATE_G_PERM;
                else next_state = STATE_MONITOR_Y_2;
            end

            STATE_MONITOR_Y_2: begin
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
