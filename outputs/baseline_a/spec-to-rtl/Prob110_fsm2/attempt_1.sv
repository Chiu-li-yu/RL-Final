module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    typedef enum logic {
        OFF = 1'b0,
        ON  = 1'b1
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            OFF: begin
                if (j) next_state = ON;
                else   next_state = OFF;
            end
            ON: begin
                if (k) next_state = OFF;
                else   next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end

    assign out = (state == ON);

endmodule
