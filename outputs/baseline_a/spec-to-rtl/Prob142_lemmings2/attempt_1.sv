module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output logic walk_left,
    output logic walk_right,
    output logic aaah
);

    typedef enum logic [3:0] {
        LEFT,
        RIGHT,
        FALL_LEFT,
        FALL_RIGHT
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;
                else if (bump_left)
                    next_state = RIGHT;
                else if (bump_right)
                    next_state = LEFT;
                else
                    next_state = LEFT;
            end
            RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;
                else if (bump_right)
                    next_state = LEFT;
                else if (bump_left)
                    next_state = RIGHT;
                else
                    next_state = RIGHT;
            end
            FALL_LEFT: begin
                if (ground)
                    next_state = LEFT;
                else
                    next_state = FALL_LEFT;
            end
            FALL_RIGHT: begin
                if (ground)
                    next_state = RIGHT;
                else
                    next_state = FALL_RIGHT;
            end
            default: next_state = LEFT;
        endcase
    end

    always_comb begin
        walk_left  = (state == LEFT);
        walk_right = (state == RIGHT);
        aaah       = (state == FALL_LEFT || state == FALL_RIGHT);
    end

endmodule
