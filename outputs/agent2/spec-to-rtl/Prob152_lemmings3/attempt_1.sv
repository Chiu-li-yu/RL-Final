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

    parameter LEFT    = 3'd0;
    parameter RIGHT   = 3'd1;
    parameter D_LEFT  = 3'd2;
    parameter D_RIGHT = 3'd3;
    parameter F_LEFT  = 3'd4;
    parameter F_RIGHT = 3'd5;

    logic [2:0] state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground) next_state = F_LEFT;
                else if (dig) next_state = D_LEFT;
                else if (bump_right) next_state = RIGHT;
                else if (bump_left) next_state = RIGHT; // Bumped on left = switch to right
                else next_state = LEFT;
            end
            RIGHT: begin
                if (!ground) next_state = F_RIGHT;
                else if (dig) next_state = D_RIGHT;
                else if (bump_left) next_state = LEFT;
                else if (bump_right) next_state = LEFT; // Bumped on right = switch to left
                else next_state = RIGHT;
            end
            D_LEFT: begin
                if (!ground) next_state = F_LEFT;
                else next_state = D_LEFT;
            end
            D_RIGHT: begin
                if (!ground) next_state = F_RIGHT;
                else next_state = D_RIGHT;
            end
            F_LEFT: begin
                if (ground) next_state = LEFT;
                else next_state = F_LEFT;
            end
            F_RIGHT: begin
                if (ground) next_state = RIGHT;
                else next_state = F_RIGHT;
            end
            default: next_state = LEFT;
        endcase
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == F_LEFT || state == F_RIGHT);
    assign digging    = (state == D_LEFT || state == D_RIGHT);

endmodule
