module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);

    // Moore machine for 2's complement
    // State 0: Haven't seen the first '1' yet
    // State 1: Have seen at least one '1'
    
    typedef enum logic {
        STATE_WAIT = 1'b0,
        STATE_FLIP = 1'b1
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_WAIT;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            STATE_WAIT: begin
                if (x == 1'b1) begin
                    next_state = STATE_FLIP;
                end else begin
                    next_state = STATE_WAIT;
                end
            end
            STATE_FLIP: begin
                next_state = STATE_FLIP;
            end
            default: next_state = STATE_WAIT;
        endcase
    end

    always @(*) begin
        case (current_state)
            STATE_WAIT: begin
                z = x; // Output 0 until the first 1, then output that 1
            end
            STATE_FLIP: begin
                z = ~x; // Invert all bits after the first 1
            end
            default: z = 1'b0;
        endcase
    end

endmodule
