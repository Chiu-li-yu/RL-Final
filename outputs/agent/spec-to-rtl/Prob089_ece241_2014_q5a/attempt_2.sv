module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);

    typedef enum logic {
        S_WAIT = 1'b0,
        S_INVERT = 1'b1
    } state_t;

    state_t state, next_state;

    // Sequential part: State transition and Output Registering (Moore)
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WAIT;
            z <= 1'b0;
        end else begin
            state <= next_state;
            case (next_state)
                S_WAIT: z <= 1'b0;
                S_INVERT: z <= !x;
            endcase
        end
    end

    // Combinational part: Next state logic
    always @(*) begin
        case (state)
            S_WAIT: begin
                if (x)
                    next_state = S_INVERT;
                else
                    next_state = S_WAIT;
            end
            S_INVERT: begin
                next_state = S_INVERT;
            end
            default: next_state = S_WAIT;
        endcase
    end

endmodule
