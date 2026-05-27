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
        WALK_LEFT  = 4'b0001,
        WALK_RIGHT = 4'b0010,
        FALL_LEFT  = 4'b0100,
        FALL_RIGHT = 4'b1000
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else if (bump_right)
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else if (bump_left)
                    next_state = WALK_RIGHT;
            end
            FALL_LEFT: begin
                if (ground)
                    next_state = WALK_LEFT;
            end
            FALL_RIGHT: begin
                if (ground)
                    next_state = WALK_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    always @(*) begin
        walk_left  = (state == WALK_LEFT);
        walk_right = (state == WALK_RIGHT);
        aaah       = (state == FALL_LEFT || state == FALL_RIGHT);
    end

endmodule
