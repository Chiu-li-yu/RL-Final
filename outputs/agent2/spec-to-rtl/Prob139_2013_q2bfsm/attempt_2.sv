module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);
    localparam IDLE = 0, F_STATE = 1, W1 = 2, W0 = 3, W11 = 4, Y_WAIT1 = 5, Y_WAIT2 = 6, G1 = 7, G0 = 8;

    logic [3:0] state, next_state;
    logic f_out, g_out;

    always_ff @(posedge clk) begin
        if (!resetn) state <= IDLE;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        f_out = 0;
        g_out = 0;
        case (state)
            IDLE: next_state = F_STATE;
            F_STATE: begin
                f_out = 1;
                next_state = W1;
            end
            W1: begin
                if (x) next_state = W0;
            end
            W0: begin
                if (!x) next_state = W11;
                else if (x) next_state = W0;
            end
            W11: begin
                if (x) next_state = Y_WAIT1;
                else next_state = W1;
            end
            Y_WAIT1: begin
                g_out = 1;
                if (y) next_state = G1;
                else next_state = Y_WAIT2;
            end
            Y_WAIT2: begin
                g_out = 1;
                if (y) next_state = G1;
                else next_state = G0;
            end
            G1: begin
                g_out = 1;
                next_state = G1;
            end
            G0: begin
                g_out = 0;
                next_state = G0;
            end
        endcase
    end

    assign f = f_out;
    assign g = g_out;
endmodule
