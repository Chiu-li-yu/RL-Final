module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    parameter STATE_A = 0, STATE_F = 1, STATE_X1 = 2, STATE_X10 = 3, STATE_X101 = 4, 
              STATE_G1 = 5, STATE_G_PERM = 6, STATE_G_OFF = 7;

    logic [2:0] state, next_state;
    logic [1:0] y_count;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            y_count <= 2'b00;
        end else begin
            state <= next_state;
            if (state == STATE_G1)
                y_count <= y_count + 2'b01;
            else
                y_count <= 2'b00;
        end
    end

    always @(*) begin
        next_state = state;
        f = 1'b0;
        g = 1'b0;

        case (state)
            STATE_A: next_state = STATE_F;
            STATE_F: begin
                f = 1'b1;
                next_state = STATE_X1;
            end
            STATE_X1: next_state = x ? STATE_X10 : STATE_X1;
            STATE_X10: next_state = !x ? STATE_X101 : (x ? STATE_X1 : STATE_X10);
            STATE_X101: next_state = x ? STATE_G1 : STATE_X1; // Sequence complete, next cycle is G1
            STATE_G1: begin
                g = 1'b1;
                if (y) next_state = STATE_G_PERM;
                else if (y_count >= 2'b01) next_state = STATE_G_OFF; // y not found within 2 cycles
                else next_state = STATE_G1;
            end
            STATE_G_PERM: g = 1'b1;
            STATE_G_OFF: g = 1'b0;
            default: next_state = STATE_A;
        endcase
    end
endmodule