module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);
    localparam LEFT = 0, RIGHT = 1, DIG_L = 2, DIG_R = 3, FALL_L = 4, FALL_R = 5, SPLATTER = 6;
    logic [2:0] state, next_state;
    logic [5:0] fall_timer;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else state <= next_state;
    end

    always_ff @(posedge clk or posedge areset) begin
        if (areset) fall_timer <= 0;
        else if (state == FALL_L || state == FALL_R) fall_timer <= fall_timer + 1'b1;
        else fall_timer <= 0;
    end

    always_comb begin
        next_state = state;
        case (state)
            LEFT: begin
                if (!ground) next_state = FALL_L;
                else if (dig) next_state = DIG_L;
                else if (bump_left) next_state = RIGHT;
                else if (bump_right) next_state = RIGHT;
            end
            RIGHT: begin
                if (!ground) next_state = FALL_R;
                else if (dig) next_state = DIG_R;
                else if (bump_right) next_state = LEFT;
                else if (bump_left) next_state = LEFT;
            end
            DIG_L: begin
                if (!ground) next_state = FALL_L;
            end
            DIG_R: begin
                if (!ground) next_state = FALL_R;
            end
            FALL_L: begin
                if (ground) next_state = (fall_timer > 20) ? SPLATTER : LEFT;
            end
            FALL_R: begin
                if (ground) next_state = (fall_timer > 20) ? SPLATTER : RIGHT;
            end
            SPLATTER: next_state = SPLATTER;
        endcase
    end

    always_comb begin
        walk_left = 0; walk_right = 0; digging = 0; aaah = 0;
        case (state)
            LEFT: walk_left = 1;
            RIGHT: walk_right = 1;
            DIG_L: digging = 1;
            DIG_R: digging = 1;
            FALL_L: aaah = 1;
            FALL_R: aaah = 1;
        endcase
    end
endmodule