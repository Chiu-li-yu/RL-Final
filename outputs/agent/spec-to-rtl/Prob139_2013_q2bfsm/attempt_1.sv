module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        A, F_ON, MONITOR_X, X1, X10, G_ON, G_PERM, G_OFF_PERM
    } state_t;

    state_t state, next_state;
    logic [1:0] y_count;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (!resetn || state != G_ON) begin
            y_count <= 2'b0;
        end else begin
            y_count <= y_count + 1'b1;
        end
    end

    always_comb begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            A: next_state = F_ON;
            F_ON: begin
                f = 1;
                next_state = MONITOR_X;
            end
            MONITOR_X: begin
                if (x) next_state = X1;
            end
            X1: begin
                if (!x) next_state = X10;
                else if (x) next_state = X1;
            end
            X10: begin
                if (x) next_state = G_ON;
                else next_state = MONITOR_X;
            end
            G_ON: begin
                g = 1;
                if (y) next_state = G_PERM;
                else if (y_count == 2'b10) next_state = G_OFF_PERM;
            end
            G_PERM: begin
                g = 1;
            end
            G_OFF_PERM: begin
                g = 0;
            end
        endcase
    end
endmodule
