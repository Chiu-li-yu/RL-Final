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
        STATE_C = 4'd2, // looking for x=1
        STATE_D = 4'd3, // looking for x=0
        STATE_E = 4'd4, // looking for x=1
        STATE_F = 4'd5, // g=1, checking y
        STATE_G = 4'd6, // g=1, checking y (2nd cycle)
        STATE_H = 4'd7, // g=1 forever
        STATE_I = 4'd8  // g=0 forever
    } state_t;

    logic [3:0] state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn) state <= STATE_A;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        f = 1'b0;
        g = 1'b0;

        case (state)
            STATE_A: next_state = STATE_B;
            STATE_B: begin
                f = 1'b1;
                next_state = STATE_C;
            end
            STATE_C: next_state = x ? STATE_D : STATE_C;
            STATE_D: next_state = x ? STATE_D : STATE_E;
            STATE_E: next_state = x ? STATE_F : STATE_C;
            STATE_F: begin
                g = 1'b1;
                if (y) next_state = STATE_H;
                else next_state = STATE_G;
            end
            STATE_G: begin
                g = 1'b1;
                if (y) next_state = STATE_H;
                else next_state = STATE_I;
            end
            STATE_H: g = 1'b1;
            STATE_I: g = 1'b0;
            default: next_state = STATE_A;
        endcase
    end
endmodule
