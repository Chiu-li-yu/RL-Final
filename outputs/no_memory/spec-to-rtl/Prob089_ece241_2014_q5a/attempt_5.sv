module TopModule (
    input logic clk,
    input logic areset,
    input logic x,
    output logic z
);

    typedef enum logic {
        STATE_KEEP = 1'b0,
        STATE_INVERT = 1'b1
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= STATE_KEEP;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            STATE_KEEP: begin
                if (x == 1'b1)
                    next_state = STATE_INVERT;
                else
                    next_state = STATE_KEEP;
            end
            STATE_INVERT: begin
                next_state = STATE_INVERT;
            end
            default: next_state = STATE_KEEP;
        endcase
    end

    always @(*) begin
        case (current_state)
            STATE_KEEP: begin
                z = x;
            end
            STATE_INVERT: begin
                z = ~x;
            end
            default: z = 1'b0;
        endcase
    end

endmodule
