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

    parameter WALKING_LEFT = 3'd0,
              WALKING_RIGHT = 3'd1,
              FALLING_LEFT = 3'd2,
              FALLING_RIGHT = 3'd3,
              DIGGING_LEFT = 3'd4,
              DIGGING_RIGHT = 3'd5;

    logic [2:0] state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALKING_LEFT;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            WALKING_LEFT: begin
                if (!ground) next_state = FALLING_LEFT;
                else if (dig) next_state = DIGGING_LEFT;
                else if (bump_left || bump_right) next_state = WALKING_RIGHT; // Handle bump
                else next_state = WALKING_LEFT;
            end
            WALKING_RIGHT: begin
                if (!ground) next_state = FALLING_RIGHT;
                else if (dig) next_state = DIGGING_RIGHT;
                else if (bump_left || bump_right) next_state = WALKING_LEFT; // Handle bump
                else next_state = WALKING_RIGHT;
            end
            FALLING_LEFT: begin
                if (ground) next_state = WALKING_LEFT;
                else next_state = FALLING_LEFT;
            end
            FALLING_RIGHT: begin
                if (ground) next_state = WALKING_RIGHT;
                else next_state = FALLING_RIGHT;
            end
            DIGGING_LEFT: begin
                if (!ground) next_state = FALLING_LEFT;
                else next_state = DIGGING_LEFT;
            end
            DIGGING_RIGHT: begin
                if (!ground) next_state = FALLING_RIGHT;
                else next_state = DIGGING_RIGHT;
            end
            default: next_state = WALKING_LEFT;
        endcase
    end

    assign walk_left = (state == WALKING_LEFT || state == DIGGING_LEFT);
    assign walk_right = (state == WALKING_RIGHT || state == DIGGING_RIGHT);
    assign aaah = (state == FALLING_LEFT || state == FALLING_RIGHT);
    assign digging = (state == DIGGING_LEFT || state == DIGGING_RIGHT);

endmodule