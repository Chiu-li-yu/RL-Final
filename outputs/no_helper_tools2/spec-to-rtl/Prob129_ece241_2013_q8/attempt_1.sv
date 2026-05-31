module TopModule (
    input clk,
    input aresetn,
    input x,
    output logic z
);

    typedef enum logic [1:0] {
        S_IDLE = 2'b00,
        S_1    = 2'b01,
        S_10   = 2'b10
    } state_t;

    state_t state, next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        z = 1'b0;

        case (state)
            S_IDLE: begin
                if (x) next_state = S_1;
                else   next_state = S_IDLE;
            end
            S_1: begin
                if (x) next_state = S_1;
                else   next_state = S_10;
            end
            S_10: begin
                if (x) begin
                    next_state = S_1;
                    z = 1'b1;
                end else begin
                    next_state = S_IDLE;
                end
            end
            default: next_state = S_IDLE;
        endcase
    end

endmodule
