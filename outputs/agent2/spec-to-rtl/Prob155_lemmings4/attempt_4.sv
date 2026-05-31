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
        if (areset) begin
            state <= LEFT;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            if (state == FALL_L || state == FALL_R) fall_timer <= fall_timer + 1'b1;
            else fall_timer <= 0;
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            LEFT: begin
                if (!ground) next_state = FALL_L;
                else if (dig) next_state = DIG_L;
                else if (bump_left || bump_right) next_state = RIGHT;
            end
            RIGHT: begin
                if (!ground) next_state = FALL_R;
                else if (dig) next_state = DIG_R;
                else if (bump_left || bump_right) next_state = LEFT;
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

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign digging    = (state == DIG_L || state == DIG_R);
    assign aaah       = (state == FALL_L || state == FALL_R);
endmodule