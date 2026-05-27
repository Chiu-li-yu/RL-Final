module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);

    // Moore State Machine for 2's complementer
    // State 0: Haven't seen the first '1' yet (or processing 0s before the first 1)
    // State 1: Have seen the first '1', now invert everything
    
    typedef enum logic {
        S_WAIT = 1'b0,
        S_INVERT = 1'b1
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WAIT;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S_WAIT: begin
                if (x)
                    next_state = S_INVERT;
                else
                    next_state = S_WAIT;
                z = x;
            end
            S_INVERT: begin
                next_state = S_INVERT;
                z = !x;
            end
            default: begin
                next_state = S_WAIT;
                z = 1'b0;
            end
        endcase
    end

endmodule
