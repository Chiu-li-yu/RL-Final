module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    typedef enum logic [2:0] {
        WALK_LEFT, WALK_RIGHT, FALL_LEFT, FALL_RIGHT, DIG_LEFT, DIG_RIGHT, SPLATTER
    } state_t;

    logic [2:0] state, next_state;
    logic [4:0] fall_count;
    logic [4:0] next_fall_count;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'b0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    always @(*) begin
        next_state = state;
        next_fall_count = fall_count;

        case (state)
            WALK_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
                else if (dig) next_state = DIG_LEFT;
                else if (bump_left) next_state = WALK_RIGHT;
                else if (bump_right) next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
                else if (dig) next_state = DIG_RIGHT;
                else if (bump_right) next_state = WALK_LEFT;
                else if (bump_left) next_state = WALK_RIGHT;
            end
            FALL_LEFT: begin
                next_fall_count = fall_count + 1'b1;
                if (ground) begin
                    next_state = (fall_count >= 20) ? SPLATTER : WALK_LEFT;
                    next_fall_count = 5'b0;
                end
            end
            FALL_RIGHT: begin
                next_fall_count = fall_count + 1'b1;
                if (ground) begin
                    next_state = (fall_count >= 20) ? SPLATTER : WALK_RIGHT;
                    next_fall_count = 5'b0;
                end
            end
            DIG_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
            end
            DIG_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
            end
            SPLATTER: begin
                next_state = SPLATTER;
            end
        endcase
    end

    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule