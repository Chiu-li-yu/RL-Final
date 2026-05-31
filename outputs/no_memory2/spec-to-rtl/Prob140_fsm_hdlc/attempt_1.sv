module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S_IDLE = 4'd0,
        S_1    = 4'd1,
        S_11   = 4'd2,
        S_111  = 4'd3,
        S_1111 = 4'd4,
        S_11111 = 4'd5,
        S_DISC  = 4'd6,
        S_111111 = 4'd7,
        S_FLAG   = 4'd8,
        S_ERR    = 4'd9
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        disc = 0;
        flag = 0;
        err = 0;

        case (state)
            S_IDLE: begin
                if (in) next_state = S_1;
                else    next_state = S_IDLE;
            end
            S_1: begin
                if (in) next_state = S_11;
                else    next_state = S_IDLE;
            end
            S_11: begin
                if (in) next_state = S_111;
                else    next_state = S_IDLE;
            end
            S_111: begin
                if (in) next_state = S_1111;
                else    next_state = S_IDLE;
            end
            S_1111: begin
                if (in) next_state = S_11111;
                else    next_state = S_IDLE;
            end
            S_11111: begin
                if (in) next_state = S_111111;
                else    next_state = S_DISC;
            end
            S_DISC: begin
                disc = 1;
                if (in) next_state = S_1;
                else    next_state = S_IDLE;
            end
            S_111111: begin
                if (in) next_state = S_ERR;
                else    next_state = S_FLAG;
            end
            S_FLAG: begin
                flag = 1;
                if (in) next_state = S_1;
                else    next_state = S_IDLE;
            end
            S_ERR: begin
                err = 1;
                if (in) next_state = S_ERR;
                else    next_state = S_IDLE;
            end
            default: next_state = S_IDLE;
        endcase
    end
endmodule
