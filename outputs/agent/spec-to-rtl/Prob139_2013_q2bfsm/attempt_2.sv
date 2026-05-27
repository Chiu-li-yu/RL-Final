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
        S_WAIT_X1,
        S_WAIT_X0,
        S_WAIT_X1_FINAL,
        S_G_ACTIVE,
        S_MONITOR_Y,
        S_G_PERM,
        S_G_OFF
    } state_t;

    state_t state, next_state;
    logic [1:0] y_count;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= S_RESET;
            y_count <= 0;
        end else begin
            state <= next_state;
            if (state == S_G_ACTIVE) begin
                y_count <= 0;
            end else if (state == S_MONITOR_Y) begin
                y_count <= y_count + 1'b1;
            end
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
                next_state = S_WAIT_X1;
            end

            S_WAIT_X1: begin
                if (x) next_state = S_WAIT_X0;
            end

            S_WAIT_X0: begin
                if (!x) next_state = S_WAIT_X1_FINAL;
                else next_state = S_WAIT_X0;
            end

            S_WAIT_X1_FINAL: begin
                if (x) next_state = S_G_ACTIVE;
                else next_state = S_WAIT_X1;
            end

            S_G_ACTIVE: begin
                g = 1;
                next_state = S_MONITOR_Y;
            end

            S_MONITOR_Y: begin
                g = 1;
                if (y) next_state = S_G_PERM;
                else if (y_count == 2'b10) next_state = S_G_OFF;
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
