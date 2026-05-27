module TopModule (
    input logic clk,
    input logic resetn,
    input logic x,
    input logic y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        S_RESET,
        S_F1,
        S_SEQ_START,
        S_SEQ_1,
        S_SEQ_10,
        S_G_ON_NEXT,
        S_MONITOR_Y_1,
        S_MONITOR_Y_2,
        S_G_PERM,
        S_G_OFF
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= S_RESET;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            S_RESET: next_state = S_F1;
            S_F1: begin
                f = 1;
                next_state = S_SEQ_START;
            end
            S_SEQ_START: begin
                if (x) next_state = S_SEQ_1;
            end
            S_SEQ_1: begin
                if (!x) next_state = S_SEQ_10;
                else next_state = S_SEQ_1;
            end
            S_SEQ_10: begin
                if (x) next_state = S_G_ON_NEXT;
                else next_state = S_SEQ_START;
            end
            S_G_ON_NEXT: begin
                g = 1;
                next_state = S_MONITOR_Y_1;
            end
            S_MONITOR_Y_1: begin
                g = 1;
                if (y) next_state = S_G_PERM;
                else next_state = S_MONITOR_Y_2;
            end
            S_MONITOR_Y_2: begin
                g = 1;
                if (y) next_state = S_G_PERM;
                else next_state = S_G_OFF;
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
