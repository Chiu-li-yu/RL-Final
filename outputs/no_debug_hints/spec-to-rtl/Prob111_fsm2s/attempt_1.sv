module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);
    typedef enum logic {OFF = 1'b0, ON = 1'b1} state_t;
    state_t state, next_state;

    assign out = (state == ON);

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            OFF: begin
                if (j) next_state = ON;
                else next_state = OFF;
            end
            ON: begin
                if (k) next_state = OFF;
                else next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end
endmodule
