module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    output logic start_shifting
);

    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001,
        S11  = 3'b010,
        S110 = 3'b011,
        FOUND = 3'b100
    } state_t;

    state_t state, next_state;

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:  next_state = (data) ? S1 : IDLE;
            S1:    next_state = (data) ? S11 : IDLE;
            S11:   next_state = (data) ? S11 : S110;
            S110:  next_state = (data) ? FOUND : IDLE;
            FOUND: next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == FOUND)
                start_shifting <= 1'b1;
        end
    end

endmodule
