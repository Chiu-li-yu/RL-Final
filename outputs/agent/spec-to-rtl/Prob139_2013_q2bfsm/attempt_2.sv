module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    localparam A = 0, F_ON = 1, MONITOR_X = 2, X1 = 3, X10 = 4, G_ON = 5, G_PERM = 6, G_OFF_PERM = 7;
    logic [2:0] state, next_state;
    logic [1:0] y_count;

    always_ff @(posedge clk) begin
        if (!resetn) state <= A;
        else state <= next_state;
    end

    always_ff @(posedge clk) begin
        if (!resetn) y_count <= 2'b0;
        else if (state == G_ON) y_count <= y_count + 1'b1;
        else y_count <= 2'b0;
    end

    always @(*) begin
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
                if (x) next_state = X1;
                else next_state = X10;
            end
            X10: begin
                if (x) next_state = G_ON;
                else next_state = MONITOR_X;
            end
            G_ON: begin
                g = 1;
                if (y) next_state = G_PERM;
                else if (y_count == 2'b01) next_state = G_OFF_PERM; // count 0 and 1, total 2 cycles
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
