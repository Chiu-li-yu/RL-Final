module TopModule(
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
    logic [5:0] fall_counter;
    logic [5:0] next_fall_counter;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            fall_counter <= next_fall_counter;
        end
    end

    always @(*) begin
        next_state = state;
        next_fall_counter = fall_counter;

        case (state)
            WALK_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
                else if (dig) next_state = DIG_LEFT;
                else if (bump_right) next_state = WALK_LEFT;
                else if (bump_left) next_state = WALK_RIGHT;
            end
            WALK_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
                else if (dig) next_state = DIG_RIGHT;
                else if (bump_left) next_state = WALK_RIGHT;
                else if (bump_right) next_state = WALK_LEFT;
            end
            DIG_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
            end
            DIG_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
            end
            FALL_LEFT: begin
                next_fall_counter = fall_counter + 1;
                if (ground) begin
                    next_fall_counter = 0;
                    if (fall_counter > 20) next_state = SPLATTER;
                    else next_state = WALK_LEFT;
                end
            end
            FALL_RIGHT: begin
                next_fall_counter = fall_counter + 1;
                if (ground) begin
                    next_fall_counter = 0;
                    if (fall_counter > 20) next_state = SPLATTER;
                    else next_state = WALK_RIGHT;
                end
            end
            SPLATTER: begin
                next_state = SPLATTER;
            end
        endcase
    end

    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule