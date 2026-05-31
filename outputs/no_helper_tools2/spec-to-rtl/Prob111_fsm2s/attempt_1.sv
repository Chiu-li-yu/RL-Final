module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

    typedef enum logic {
        OFF = 1'b0,
        ON  = 1'b1
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset)
            current_state <= OFF;
        else
            current_state <= next_state;
    end

    always_comb begin
        case (current_state)
            OFF: begin
                out = 1'b0;
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                out = 1'b1;
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            default: begin
                out = 1'b0;
                next_state = OFF;
            end
        endcase
    end
endmodule
