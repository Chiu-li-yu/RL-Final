module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        STATE_A = 4'd0,
        STATE_B = 4'd1, // f=1
        STATE_C = 4'd2, // saw 1
        STATE_D = 4'd3, // saw 1, 0
        STATE_E = 4'd4, // saw 1, 0, 1 -> g=1
        STATE_F = 4'd5, // g=1 permanent
        STATE_H = 4'd6, // g=0 permanent
        WAIT_Y_1 = 4'd7,
        WAIT_Y_2 = 4'd8
    } state_t;

    state_t state, next_state;
    logic [1:0] y_count;

    always @(posedge clk) begin
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
            STATE_A: next_state = STATE_B;
            STATE_B: begin
                f = 1;
                next_state = (x == 1) ? STATE_C : STATE_B;
            end
            STATE_C: begin
                if (x == 0) next_state = STATE_D;
                else if (x == 1) next_state = STATE_C;
                else next_state = STATE_B;
            end
            STATE_D: begin
                if (x == 1) next_state = STATE_E;
                else if (x == 0) next_state = STATE_B;
                else next_state = STATE_B;
            end
            STATE_E: begin
                g = 1;
                next_state = (y == 1) ? STATE_F : WAIT_Y_1;
            end
            WAIT_Y_1: begin
                g = 1;
                next_state = (y == 1) ? STATE_F : WAIT_Y_2;
            end
            WAIT_Y_2: begin
                g = 0; // failed to see y=1 in two cycles
                next_state = STATE_H;
            end
            STATE_F: begin
                g = 1;
            end
            STATE_H: begin
                g = 0;
            end
        endcase
    end

endmodule
